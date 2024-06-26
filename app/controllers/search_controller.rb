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
    @results = fetch_results(params[:job_id])
    render json: { results: @results }
  end

  private

  def fetch_results(job_id)
    SearchResult.where(job_id: job_id).pluck(:results).flatten
  end
end
