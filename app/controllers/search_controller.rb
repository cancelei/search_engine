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

      Rails.logger.info "Job ID: #{job.provider_job_id}"

      if user_signed_in?
        current_user.search_histories.create(
          query: params[:query],
          search_engine: params[:search_engine]
        )
      end

      render json: { job_id: job.provider_job_id }, status: :accepted
    else
      # render json: { error: 'Query parameter is missing' }, status: :unprocessable_entity
    end
  end

  def results
    job_id = params[:job_id]
    job = GoodJob::Job.find_by!(provider_job_id: job_id)
    if job.finished?
      query = job.serialized_params['arguments'].first['query']
      @results = fetch_results(query)
      render json: { results: @results }
    else
      render json: { results: nil }
    end
  end

  private

  def fetch_results(query)
    SearchResult.where(query: query).pluck(:results).flatten
  end
end
