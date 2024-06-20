# app/services/google_search_service.rb
require 'httparty'

class GoogleSearchService
  include HTTParty
  base_uri 'https://www.googleapis.com/customsearch/v1'

  def initialize
    @api_key = ENV['GOOGLE_API_KEY']
    @cx_key = ENV['GOOGLE_CX_KEY']
  end

  def search(query, options = {})
    options.merge!({
      q: query,
      key: @api_key,
      cx: @cx_key,
      num: options[:num].to_i > 0 ? options[:num] : 10,
      safesearch: options[:safesearch] || 'off'
    })
    Rails.logger.debug "Google API Request Options: #{options.inspect}"
    self.class.get('', query: options)
  end
end
