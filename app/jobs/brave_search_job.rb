# app/jobs/brave_search_job.rb
class BraveSearchJob < ApplicationJob
  queue_as :default

  def perform(query:, country:, search_lang:, ui_lang:, count:, offset:, safesearch:)
    brave_service = BraveSearchService.new
    options = {
      country: country,
      search_lang: search_lang,
      ui_lang: ui_lang,
      count: count,
      offset: offset,
      safesearch: safesearch
    }
    results = brave_service.search(query, options)
    store_results(query, results)
  end

  private

  def store_results(query, results)
    SearchResult.create(job_id: job_id, query: query, results: results, search_engine: 'brave')
  end
end
