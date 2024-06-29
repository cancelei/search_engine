class BraveSearchJob < ApplicationJob
  queue_as :default

  def perform(query:)
    brave_service = BraveSearchService.new
    results = brave_service.search(query: query, options: {})
    store_results(query, results)
  end

  private

  def store_results(query, results)
    SearchResult.create(job_id: job_id, query: query, results: results, search_engine: 'brave')
  end
end
