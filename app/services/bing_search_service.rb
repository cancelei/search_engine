# app/services/bing_search_service.rb
require 'httparty'

class BingSearchService
  include HTTParty
  base_uri 'https://api.bing.microsoft.com/v7.0'

  def initialize(api_key)
    @api_key = api_key
  end

  def search(query)
    options = {
      headers: { "Ocp-Apim-Subscription-Key" => @api_key },
      query: { q: query }
    }
    self.class.get('/search', options)
  end
end
