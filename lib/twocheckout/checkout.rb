module Twocheckout
  class Checkout < HashObject

    @checkout_url = 'https://www.2checkout.com/checkout/purchase'

    def self.sandbox(sandbox)
      @checkout_url = sandbox ? 'https://sandbox.2checkout.com/checkout/purchase' : @checkout_url;
    end

    def self.form(params={}, button_text='Proceed to Checkout')
      @form = "<form id=\"2checkout\" action=\"#{@checkout_url}\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form + "<input type=\"submit\" value=\"" + button_text + "\" />\n</form>"
    end

    def self.submit(params={})
      @form = "<form id=\"2checkout\" action=\"#{@checkout_url}\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form = @form + "</form>\n"
      @form = @form + "<script type=\"text/javascript\">document.getElementById('2checkout').submit();</script>"
    end

    def self.direct(params={}, button_text='Proceed to Checkout')
      @form = "<form id=\"2checkout\" action=\"#{@checkout_url}\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form = @form + "<input type=\"submit\" value=\"" + button_text + "\" />\n</form>\n"
      @form = @form + "<script src=\"https://www.2checkout.com/static/checkout/javascript/direct.min.js\"></script>"
    end

    def self.link(params={})
      @querystring = params.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
      @purchase_url = @checkout_url + '?' + @querystring
    end

    def self.authorize(params={})
      response = Twocheckout::API.request(:post, 'authService', params)
      response['response']
    end
  end
end