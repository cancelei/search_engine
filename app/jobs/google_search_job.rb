class GoogleSearchJob < ApplicationJob
  queue_as :default

  def perform(query:, num:, safesearch:)
    google_service = GoogleSearchService.new
    results = google_service.search(query, num: num, safesearch: safesearch)
    store_results(query, results)
  end

  private

  def store_results(query, results)
    SearchResult.create(job_id: job_id, query: query, results: results, search_engine: 'google')
  end
end
