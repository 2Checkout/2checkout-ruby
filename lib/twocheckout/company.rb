require 'singleton'

module Twocheckout
  class Company < HashObject
    include Singleton

    #
    # Returns company info
    #
    def initialize
      response = Twocheckout::API.request(:get, 'acct/detail_company_info')
      super(response['vendor_company_info'])
    end

    #
    # Returns contact info
    #
    def contact_info
      if @contact_info.nil?
        response = Twocheckout::API.request(:get, 'acct/detail_contact_info')
        @contact_info = HashObject.new(response['vendor_contact_info'])
      end
      @contact_info
    end

    protected

    def _key
      self.vendor_id
    end

  end
end
