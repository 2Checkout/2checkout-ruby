require 'rest_client'
require 'json'

module Twocheckout
  class API
    API_BASE = 'https://www.2checkout.com/api/'

    def self.credentials=(opts)
      @@username = opts[:username]
      @@password = opts[:password]
      opts
    end

    def self.request(http_method, api_call, params = nil)
      url = API_BASE + api_call
      if http_method == :get
        url += hash_to_querystring(params)
        params = nil
      end
      opts = {
        :method => http_method,
        :url => url,
        :headers => {
            :accept => :json,
            :content_type => :json,
            :user_agent => "2Checkout/Ruby/," + Twocheckout::VERSION
        },
        :user => @@username,
        :password => @@password,
        :payload => params,
      }
      begin
        response = RestClient::Request.execute(opts)
        JSON.parse(response)
      rescue => e
        error_hash = JSON.parse(e.response)
        raise TwocheckoutError.new(error_hash['errors'][0]['message']).retrieve
      end
    end

    private

    def self.hash_to_querystring(hash)
      return '' if hash.nil? || hash.empty?
      '?' + hash.map { |k,v| "#{URI.encode(k.to_s)}=#{URI.encode(v.to_s)}" }.join('&')
    end

  end
end