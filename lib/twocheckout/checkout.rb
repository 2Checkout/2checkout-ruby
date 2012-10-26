module Twocheckout
  class Checkout

    def self.form(params={})
      @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/spurchase\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form + "<input type=\"submit\" value=\"Proceed to Checkout\" />\n</form>"
    end

    def self.submit(params={})
      @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/spurchase\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form = @form + "</form>\n"
      @form = @form + "<script type=\"text/javascript\">document.getElementById('2checkout').submit();</script>"
    end

    def self.link(params={}, url="https://www.2checkout.com/checkout/spurchase?")
      @querystring = params.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
      @purchase_url = url + @querystring
    end
  end
end