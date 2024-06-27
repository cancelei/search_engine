# app/controllers/search_controller.rb
require_relative '../services/google_search_service'
require_relative '../services/bing_search_service'
require_relative '../services/brave_search_service'

class SearchController < ApplicationController
  def index
    if params[:query].present?
      case params[:search_engine]
      when 'google'
        google_service = GoogleSearchService.new
        @results = google_service.search(
          params[:query],
          num: params[:count].presence || 10,
          safesearch: params[:safesearch].presence || 'off'
        )
      when 'bing'
        bing_service = BingSearchService.new
        @results = bing_service.search(
          query: params[:query],
          count: params[:count].presence || 10,
          mkt: params[:mkt],
          safesearch: params[:safesearch],
          freshness: params[:freshness],
          sortby: params[:sortby]
        )
      when 'brave'
        brave_service = BraveSearchService.new
        @results = brave_service.search(
          params[:query],
          country: 'us',
          search_lang: 'en',
          ui_lang: 'en-US',
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

      Rails.logger.debug "Search API Response: #{@results.inspect}"
    end
  end
end
