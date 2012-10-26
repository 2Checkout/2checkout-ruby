module Twocheckout
  class Coupon < HashObject

    def self.find(options)
      response = Twocheckout::API.request(:get, 'products/detail_coupon', options)
      Coupon.new(response['coupon'])
    end

    def self.with_coupon_code(coupon_code)
      find(:coupon_code => coupon_code)
    end

    def self.create(opts)
      response = Twocheckout::API.request(:post, 'products/create_coupon', opts)
      find(:coupon_code => response['coupon_code'])
    end

    def update(opts)
      opts = opts.merge(:coupon_code => self.coupon_code)
      Twocheckout::API.request(:post, 'products/update_coupon', opts)
      response = Twocheckout::API.request(:get, 'products/detail_coupon', opts)
      Coupon.new(response['coupon'])
    end

    def delete!
      opts = {:coupon_code => self.coupon_code}
      Twocheckout::API.request(:post, 'products/delete_coupon', opts)
    end

    def self.list(opts=nil)
      Twocheckout::API.request(:get, 'products/list_coupons', opts)
    end

    protected

    def _key
      self.coupon_code
    end

  end
end
