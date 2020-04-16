require 'rest_client'
require 'json'

module Twocheckout
  class API
    PROD_BASE = 'https://www.2checkout.com'
    API_VERSION = '1'

    def self.credentials=(opts)
      @username = opts[:username]
      @password = opts[:password]
      @private_key = opts[:private_key]
      @seller_id = opts[:seller_id]
    end

    def self.request(http_method, api_call, params = nil)
      opts = set_opts(http_method, api_call, params)
      begin
        response = RestClient::Request.execute(opts)
        JSON.parse(response)
      rescue => e
        error_hash = JSON.parse(e.response)
        if error_hash['exception']
          raise TwocheckoutError.new(error_hash['exception']['errorMsg'], error_hash['exception']['errorCode'])
        else
          raise TwocheckoutError.new(error_hash['errors'][0]['message'])
        end
      end
    end

    private

    def self.set_opts(http_method, api_call, params = null)
      url = PROD_BASE
      if api_call == 'authService'
        url += '/checkout/api/' + API_VERSION + '/' + @seller_id + '/rs/' + api_call
        params['sellerId'] = @seller_id
        params['privateKey'] = @private_key
        opts = {
          :method => http_method,
          :url => url,
          :headers => {
              :accept => :json,
              :content_type => :json,
              :user_agent => "2Checkout/Ruby/," + Twocheckout::VERSION
          },
          :payload => params.to_json,
        }
      else
        url += '/api/' + api_call
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
          :user => @username,
          :password => @password,
          :payload => params,
        }
      end

      return opts
    end

    def self.hash_to_querystring(hash)
      return '' if hash.nil? || hash.empty?
      '?' + hash.map { |k,v| "#{URI.encode(k.to_s)}=#{URI.encode(v.to_s)}" }.join('&')
    end

  end
end
