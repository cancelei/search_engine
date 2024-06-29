# app/controllers/search_controller.rb
require_relative '../services/google_search_service'
require_relative '../services/bing_search_service'
require_relative '../services/brave_search_service'

class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params[:query].present?
      job = case params[:search_engine]
            when 'google'
              GoogleSearchJob.perform_later(
                query: params[:query],
                num: params[:count].presence || 10,
                safesearch: params[:safesearch].presence || 'off'
              )
            when 'bing'
              BingSearchJob.perform_later(
                query: params[:query],
                count: params[:count].presence || 10,
                mkt: params[:mkt],
                safesearch: params[:safesearch],
                freshness: params[:freshness],
                sortby: params[:sortby]
              )
            when 'brave'
              BraveSearchJob.perform_later(
                query: params[:query],
                country: params[:country] || 'us',
                search_lang: params[:search_lang] || 'en',
                ui_lang: params[:ui_lang] || 'en-US',
                count: params[:count].presence || 20,
                offset: params[:offset].presence || 0,
                safesearch: params[:safesearch].presence || 'moderate'
              )
            end

      if user_signed_in?
        current_user.search_histories.create(
          query: params[:query],
          search_engine: params[:search_engine]
        )
      end

      render json: { job_id: job.job_id }, status: :accepted
    else
      # render json: { error: 'Query parameter is missing' }, status: :unprocessable_entity
    end
  end

  def results
    raw_results = fetch_results(params[:job_id])
    search_engine = SearchResult.find_by(job_id: params[:job_id])&.search_engine

    Rails.logger.debug "Raw results: #{raw_results.inspect}"

    formatted_results = case search_engine
                        when 'google'
                          format_google_results(raw_results)
                        when 'bing'
                          format_bing_results(raw_results)
                        when 'brave'
                          format_brave_results(raw_results)
                        end

    Rails.logger.debug "Formatted results: #{formatted_results.inspect}"

    render json: { results: formatted_results }
  end

  private

  def fetch_results(job_id)
    SearchResult.where(job_id: job_id).pluck(:results).map { |result| JSON.parse(result) }
  end

  def format_google_results(results)
    results.map do |parsed_result|
      # Rails.logger.debug "Parsed Google result: #{parsed_result.inspect}"
      {
        search_terms: parsed_result.dig('queries', 'request', 0, 'searchTerms'),
        total_results: parsed_result.dig('searchInformation', 'formattedTotalResults'),
        search_time: parsed_result.dig('searchInformation', 'formattedSearchTime'),
        items: format_google_items(parsed_result['items'] || [])
      }
    end
  end

  def format_google_items(items)
    items.map do |item|
      # Rails.logger.debug "Google item: #{item.inspect}"
      {
        title: item['title'],
        link: item['link'],
        snippet: item['snippet'],
        display_link: item['displayLink'],
        formatted_url: item['formattedUrl']
      }
    end
  end

  def format_bing_results(results)
    results.map do |parsed_result|
      {
        search_terms: parsed_result.dig('queryContext', 'originalQuery'),
        total_results: parsed_result.dig('webPages', 'totalEstimatedMatches'),
        search_url: parsed_result.dig('webPages', 'webSearchUrl'),
        items: format_bing_items(parsed_result.dig('webPages', 'value') || [])
      }
    end
  end

  def format_bing_items(items)
    items.map do |item|
      {
        title: item['name'],
        link: item['url'],
        snippet: item['snippet'],
        display_link: item['displayUrl'],
        date_published: item['datePublishedDisplayText'],
        cached_page_url: item['cachedPageUrl']
      }
    end
  end

  def format_brave_results(results)
    results.map do |parsed_result|
      Rails.logger.debug "Parsed Brave result: #{parsed_result.inspect}"

      if parsed_result['type'] == 'ErrorResponse'
        {
          search_terms: parsed_result.dig('query', 'original') || 'Unknown',
          total_results: nil,
          search_time: nil,
          items: [],
          error: parsed_result.dig('error', 'detail')
        }
      else
        {
          search_terms: parsed_result.dig('query', 'original'),
          total_results: nil, # Assuming Brave does not return a total results count in the same way
          search_time: nil,   # Assuming Brave does not return a search time in the same way
          items: format_brave_items(parsed_result)
        }
      end
    end
  end

  def format_brave_items(parsed_result)
    web_items = parsed_result.dig('mixed', 'main') || []
    video_items = parsed_result.dig('videos', 'results') || []

    formatted_web_items = web_items.map do |item|
      next unless item['type'] == 'web'

      {
        title: item['title'] || 'No title available',
        link: item['url'] || '',
        snippet: item['description'] || 'No description available',
        display_link: item.dig('meta_url', 'hostname') || '',
        formatted_url: item.dig('meta_url', 'path') || ''
      }
    end.compact

    formatted_video_items = video_items.map do |item|
      {
        title: item['title'] || 'No title available',
        link: item['url'] || '',
        snippet: item['description'] || 'No description available',
        display_link: item.dig('meta_url', 'hostname') || '',
        formatted_url: item.dig('meta_url', 'path') || '',
        thumbnail: item.dig('thumbnail', 'src') || ''
      }
    end

    formatted_web_items + formatted_video_items
  end

end
