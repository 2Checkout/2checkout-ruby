module Twocheckout
  class Product < HashObject

    #
    # Finds product by ID and returns a Product object
    #
    def self.find(opts)
      response = Twocheckout::API.request(:get, 'products/detail_product', opts)
      Product.new(response['product'])
    end

    def self.with_product_id(product_id)
      find(:product_id => product_id)
    end

    #
    # Creates a new product and returns the Product object
    #
    def self.create(opts)
      response = Twocheckout::API.request(:post, 'products/create_product', opts)
      find(:product_id => response['product_id'])
    end

    #
    # Updates product and returns a new Product object
    #
    def update(opts)
      opts = opts.merge(:product_id => self.product_id)
      Twocheckout::API.request(:post, 'products/update_product', opts)
      response = Twocheckout::API.request(:get, 'products/detail_product', opts)
      Product.new(response['product'])
    end

    #
    # Deletes the product and returns the response
    #
    def delete!
      opts = {:product_id => self.product_id}
      Twocheckout::API.request(:post, 'products/delete_product', opts)
    end

    #
    # Get product list in an array
    #
    def self.list(opts)
      response = Twocheckout::API.request(:get, 'products/list_products', opts)
      response['products']
    end

    protected

    def _key
      self.product_id
    end

  end
end
