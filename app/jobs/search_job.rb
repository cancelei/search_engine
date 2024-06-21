class SearchJob < ApplicationJob
  queue_as :default

  def perform(params, user_id = nil)
    results = if params['search_engine'] == 'google'
                google_service = GoogleSearchService.new
                google_service.search(
                  params['query'],
                  num: params['count'].presence || 10,
                  safesearch: params['safesearch'].presence || 'off'
                )
              else
                bing_service = BingSearchService.new
                bing_service.search(
                  query: params['query'],
                  count: params['count'].presence || 10,
                  mkt: params['mkt'],
                  safesearch: params['safesearch'],
                  freshness: params['freshness'],
                  sortby: params['sortby']
                )
              end

    # Save the search history if user_id is provided
    if user_id
      user = User.find(user_id)
      user.search_histories.create(query: params['query'], search_engine: params['search_engine'])
    end

    # Store the results in SearchResult
    search_result = SearchResult.create(job_id: self.job_id, results: results.to_json)

    # Broadcast the results using Turbo Streams
    Turbo::StreamsChannel.broadcast_replace_to(
      "search_results_#{self.job_id}",
      target: "search_results_#{self.job_id}",
      partial: "search/search_results",
      locals: { results: JSON.parse(search_result.results) }
    )
  end
end
