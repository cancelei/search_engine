class SearchController < ApplicationController
  def index
    if params[:query].present?
      job = SearchJob.perform_later(params.to_unsafe_h, current_user&.id)
      @job_id = job.job_id
    end

    if params[:job_id]
      search_result = SearchResult.find_by(job_id: params[:job_id])
      @results = JSON.parse(search_result.results) if search_result
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "search/search_results" }
    end
  end
end
