module Twocheckout
  class LineItem < HashObject

    def refund!(opts)
      opts = opts.merge(:lineitem_id => self.lineitem_id)
      Twocheckout::API.request(:post, 'sales/refund_lineitem', opts)
    end

    def active?
      self.billing.recurring_status == 'active'
    end

    def stop_recurring!
      Twocheckout::API.request(:post, 'sales/stop_lineitem_recurring', lineitem_id: self.lineitem_id)
    end

    #
    # Provide access to update existing recurring lineitems by allowing to lower the lineitem price
    # and push the recurring billing date forward. This call is not currently documented in the
    # 2Checkout API documentation.
    #
    # POST https://www.2checkout.com/api/sales/update_lineitem_recurring
    #
    # Parameters:
    # * (required) lineitem_id: lineitem_id
    # * (optional) comment: Optional comment added to sale
    # * (optional) shift: days to shift next recurring payment forward
    # * (optional) price: new recurring price (must be lower than previous price or else call will fail)
    #
    # The shift and price parameters are optional, but at least one of them must be provided for the
    # call to be valid.
    #
    # Example Shift Date Next
    # curl -X POST https://www.2checkout.com/api/sales/update_lineitem_recurring -u \
    # 'username:password' -d 'lineitem_id=1234567890' -d 'shift=7' -H 'Accept: application/json'
    #
    # Example Update Price
    # curl -X POST https://www.2checkout.com/api/sales/update_lineitem_recurring -u \
    # 'username:password' -d 'lineitem_id=1234567890' -d 'price=1.00' -H 'Accept: application/json'
    #
    # Please note that this method cannot be used on PayPal sales as 2Checkout cannot alter the
    # customer's billing agreement so this call can only update a recurring lineitem on credit card
    # sales.
    #
    def update_recurring!(opts)
      opts = opts.merge(:lineitem_id => self.lineitem_id)
      Twocheckout::API.request(:post, 'sales/update_lineitem_recurring', opts)
    end

    protected

    def _key
      self.lineitem_id
    end

  end
end
