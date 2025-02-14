class BingSearchJob < ApplicationJob
  queue_as :default

  def perform(query:, count:, mkt:, safesearch:, freshness:, sortby:)
    bing_service = BingSearchService.new
    results = bing_service.search(query: query, count: count, mkt: mkt, safesearch: safesearch, freshness: freshness, sortby: sortby)
    store_results(query, results)
  end

  private

  def store_results(query, results)
    SearchResult.create(job_id: job_id, query: query, results: results, search_engine: 'bing')
  end
end
