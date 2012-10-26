require 'digest/md5'

module Twocheckout
  class ValidateResponse

    # Checks against MD5 Hash
    def self.valid?(arg1, arg2, arg3, arg4, key)
      Digest::MD5.hexdigest("#{arg1}#{arg2}#{arg3}#{arg4}").upcase == key
    end

    def self.purchase(options)
      options[:demo] == 'Y' ? 1 : options[:order_number]
      if valid?(options[:secret], options[:sid], options[:order_number], options[:total], options[:key])
        {:code => "PASS", :message => "Hash Matched"}
      else
        {:code => "FAIL", :message => "Hash Mismatch"}
      end
    end

    def self.notification(options)
      if valid?(options[:sale_id], options[:vendor_id], options[:invoice_id], options[:secret], options[:md5_hash])
        {:code => "PASS", :message => "Hash Matched"}
      else
        {:code => "FAIL", :message => "Hash Mismatch"}
      end
    end
  end
end
