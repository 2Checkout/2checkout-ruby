module Twocheckout
  class Sale < HashObject

    def self.find(options)
      response = Twocheckout::API.request(:get, 'sales/detail_sale', options)
      Sale.new(response['sale'])
    end

    def self.with_sale_id(sale_id)
      find(:sale_id => sale_id)
    end

    def self.with_invoice_id(invoice_id)
      find(:invoice_id => invoice_id)
    end

    #
    # An array of all invoices in this sale
    #
    def invoices
      if @invoices.nil?
        @invoices = @hash['invoices'].map { |i| Twocheckout::Invoice.new(i) }
        @invoices.freeze
      end
      @invoices
    end

    #
    # A hash to index invoices by id
    #
    def invoice
      if @invoice.nil?
        @invoice = {}
        invoices.each { |inv| @invoice[inv.invoice_id] = inv }
        @invoice.freeze
      end
      return @invoice
    end

    #
    # Refund sale
    #
    def refund!(opts)
      opts = opts.merge(:sale_id => self.sale_id)
      Twocheckout::API.request(:post, 'sales/refund_invoice', opts)
    end

    #
    # Get active recurring lineitems from the most recent invoice
    #
    def active_lineitems
      invoices.last.active_lineitems
    end

    #
    # Stop all active recurring lineitems
    #
    def stop_recurring!
      active_lineitems.each { |li| li.stop_recurring! }
    end

    #
    # Add a sale comment
    #
    def comment(opts)
      opts = opts.merge(:sale_id => self.sale_id)
      Twocheckout::API.request(:post, 'sales/create_comment', opts)
    end

    #
    # Mark tangible sale as shipped
    #
    def ship(opts)
      opts = opts.merge(:sale_id => self.sale_id)
      Twocheckout::API.request(:post, 'sales/mark_shipped', opts)
    end

    #
    # Reauthorize sale
    #
    def reauth
      Twocheckout::API.request(:post, 'sales/reauth', sale_id: self.sale_id)
    end

    #
    # Get sale list in an array
    #
    def self.list(opts)
      response = Twocheckout::API.request(:get, 'sales/list_sales', opts)
      response['sale_summary']
    end

    protected

    def _key
      self.sale_id
    end

  end
end
