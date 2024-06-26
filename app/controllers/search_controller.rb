# app/controllers/search_controller.rb
require_relative '../services/google_search_service'
require_relative '../services/bing_search_service'

class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params[:query].present?
      job = if params[:search_engine] == 'google'
              GoogleSearchJob.perform_later(
                query: params[:query],
                num: params[:count].presence || 10,
                safesearch: params[:safesearch].presence || 'off'
              )
            else
              BingSearchJob.perform_later(
                query: params[:query],
                count: params[:count].presence || 10,
                mkt: params[:mkt],
                safesearch: params[:safesearch],
                freshness: params[:freshness],
                sortby: params[:sortby]
              )
            end

      Rails.logger.info "Job ID: #{job.job_id}"

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

    formatted_results = if search_engine == 'google'
                          format_google_results(raw_results)
                        else
                          format_bing_results(raw_results)
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
      Rails.logger.debug "Parsed Google result: #{parsed_result.inspect}"
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
      Rails.logger.debug "Google item: #{item.inspect}"
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
end
