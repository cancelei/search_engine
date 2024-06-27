# app/services/brave_search_service.rb
require 'httparty'

class BraveSearchService
  include HTTParty
  base_uri 'https://api.search.brave.com/res/v1/web'

  def initialize
    @api_key = ENV['BRAVE_API_KEY']
  end

  def search(query, options = {})
    headers = {
      "Accept" => "application/json",
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
      "X-Subscription-Token" => @api_key
    }

    options = options.transform_values(&:presence).compact

    # Minimal set of options for validation
    options.merge!({
      q: query,
      key: @api_key,
      country: options[:country] || 'us',
      search_lang: options[:search_lang] || 'en',
      ui_lang: options[:ui_lang] || 'en-US',
      count: options[:count] || 20,
      offset: options[:offset] || 0,
      safesearch: options[:safesearch] || 'moderate'
    })

    # Brave has a sofisticated API, that is why I placed comprehensive testing for potential errors during adjustments.
    Rails.logger.debug "Brave API Request Options: #{options.inspect}"
    begin
      response = self.class.get('/search', query: options, headers: headers)
      Rails.logger.debug "Brave API Response: #{response.inspect}"
      response
    rescue SocketError => e
      Rails.logger.error "BraveSearchService SocketError: #{e.message}"
      nil
    rescue HTTParty::Error => e
      Rails.logger.error "BraveSearchService HTTP Error: #{e.message}"
      nil
    rescue StandardError => e
      Rails.logger.error "BraveSearchService Error: #{e.message}"
      nil
    end
  end
end
