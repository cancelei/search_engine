# app/controllers/search_controller.rb
require_relative '../services/google_search_service'

class SearchController < ApplicationController
  def index
    if params[:query].present?
      if params[:search_engine] == 'google'
        google_service = GoogleSearchService.new
        @results = google_service.search(
          params[:query],
          num: params[:count].presence || 10,
          safesearch: params[:safesearch].presence || 'off'
        )
      else
        bing_service = BingSearchService.new
        @results = bing_service.search(
          query: params[:query],
          count: params[:count].presence || 10,
          mkt: params[:mkt],
          safesearch: params[:safesearch],
          freshness: params[:freshness],
          sortby: params[:sortby]
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
