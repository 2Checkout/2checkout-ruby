2Checkout Ruby Library
=====================

This library provides developers with a simple set of bindings to the 2Checkout purchase routine, Instant Notification Service and Back Office API.

To use, install the `twocheckout` gem.

```shell
gem install twocheckout
```

Or import into your Gemfile.

```ruby
gem "twocheckout"
```

Full documentation for each binding is provided in the **[2Checkout Documentation](https://github.com/2checkout/2checkout-ruby/wiki)**.


Example Purchase API Usage
-----------------

*Example Usage:*

```ruby
Twocheckout::API.credentials = {
    :seller_id => '1817037',
    :private_key => '3508079E-5383-44D4-BF69-DC619C0D9811'
}

params = {
    :merchantOrderId     => '123',
    :token          => 'ZmYyMzMyZGMtZTY2NS00NDAxLTlhYTQtMTgwZWIyZTgwMzQx',
    :currency       => 'USD',
    :total          => '1.00',
    :billingAddr    => {
        :name => 'Testing Tester',
        :addrLine1 => '123 Test St',
        :city => 'Columbus',
        :state => 'OH',
        :zipCode => '43123',
        :country => 'USA',
        :email => 'cchristenson@2co.com',
        :phoneNumber => '555-555-5555'
    }
}

begin
  result = Twocheckout::Checkout.authorize(params)
rescue Exception => e
  puts e.message
end
```

*Example Response:*

```ruby
#<Twocheckout::Checkout>{
"type"=>"AuthResponse",
 "lineItems"=>
  [{"options"=>[],
    "price"=>"1.00",
    "quantity"=>"1",
    "recurrence"=>nil,
    "startupFee"=>nil,
    "productId"=>"",
    "tangible"=>"N",
    "name"=>"123",
    "type"=>"product",
    "description"=>"",
    "duration"=>nil}],
 "transactionId"=>"205180760223",
 "billingAddr"=>
  {"addrLine1"=>"123 Test St",
   "addrLine2"=>nil,
   "city"=>"Columbus",
   "zipCode"=>"43123",
   "phoneNumber"=>"555-555-5555",
   "phoneExtension"=>nil,
   "email"=>"cchristenson@2co.com",
   "name"=>"Testing Tester",
   "state"=>"OH",
   "country"=>"USA"},
 "shippingAddr"=>
  {"addrLine1"=>nil,
   "addrLine2"=>nil,
   "city"=>nil,
   "zipCode"=>nil,
   "phoneNumber"=>nil,
   "phoneExtension"=>nil,
   "email"=>nil,
   "name"=>nil,
   "state"=>nil,
   "country"=>nil},
 "merchantOrderId"=>"123",
 "orderNumber"=>"205180760214",
 "recurrentInstallmentId"=>nil,
 "responseMsg"=>"Successfully authorized the provided credit card",
 "responseCode"=>"APPROVED",
 "total"=>"1.00",
 "currencyCode"=>"USD",
 "errors"=>nil}
```


Example Admin API Usage
-----------------

*Example Usage:*

```ruby
Twocheckout::API.credentials = { :username => 'APIuser1817037', :password => 'APIpass1817037' }

sale = Twocheckout::Sale.find(:sale_id => 4838212958)
sale.stop_recurring!
```

*Example Response:*

```ruby
[
    #<Twocheckout: : LineItem: 4838213015>{
        "affiliate_vendor_id"=>nil,
        "billing"=>#<Twocheckout: : HashObject: 70259731127120>{
            "amount"=>"0.01",
            "bill_method"=>"paypal_int",
            "billing_id"=>"4838213024",
            "customer_amount"=>"0.01",
            "customer_id"=>"4838212964",
            "date_deposited"=>nil,
            "date_end"=>nil,
            "date_fail"=>"2012-10-30",
            "date_next"=>"2012-10-30",
            "date_pending"=>"2012-10-23",
            "date_start"=>"2012-10-25",
            "lineitem_id"=>"4838213015",
            "recurring_status"=>"active",
            "status"=>"bill",
            "usd_amount"=>"0.01",
            "vendor_amount"=>"0.01"
        },
        "commission"=>nil,
        "commission_affiliate_vendor_id"=>nil,
        "commission_flat_rate"=>nil,
        "commission_percentage"=>nil,
        "commission_type"=>nil,
        "commission_usd_amount"=>nil,
        "customer_amount"=>"0.01",
        "flat_rate"=>nil,
        "installment"=>"1",
        "invoice_id"=>"4838212967",
        "lc_affiliate_vendor_id"=>nil,
        "lc_usd_amount"=>nil,
        "lineitem_id"=>"4838213015",
        "linked_id"=>nil,
        "options"=>[
            {
                "customer_surcharge"=>"0.01",
                "lineitem_id"=>"4838213015",
                "lineitem_option_id"=>"4838213021",
                "option_name"=>"0.5",
                "option_value"=>"test1",
                "usd_surcharge"=>"0.01",
                "vendor_surcharge"=>"0.01"
            }
        ],
        "percentage"=>nil,
        "product_description"=>"This is a test product!",
        "product_duration"=>"Forever",
        "product_handling"=>"0.00",
        "product_id"=>"4774388564",
        "product_is_cart"=>"0",
        "product_name"=>"Example Product",
        "product_price"=>"0.01",
        "product_recurrence"=>"1 Week",
        "product_startup_fee"=>nil,
        "product_tangible"=>"0",
        "sale_id"=>"4838212958",
        "status"=>"bill",
        "type"=>nil,
        "usd_amount"=>"0.01",
        "usd_commission"=>nil,
        "vendor_amount"=>"0.01",
        "vendor_product_id"=>"example123"
    }
]
```

Example Checkout Usage:
-----------------------

*Example Usage:*

```ruby
require "sinatra"

get '/' do
  @@form = Twocheckout::Checkout.submit({ 'sid' => '1817037', 'mode' => '2CO','li_0_name' => 'Example Product', 'li_0_price' => '1.00'})
  @@form
end
```

*Example Response:*

```html
<form id="2checkout" action="https://www.2checkout.com/checkout/spurchase" method="post">
<input type="hidden" name="sid" value="1817037" />
<input type="hidden" name="mode" value="2CO" />
<input type="hidden" name="li_0_name" value="Example Product" />
<input type="hidden" name="li_0_price" value="1.00" />
</form>
<script type="text/javascript">document.getElementById('2checkout').submit();</script>
```

Example Return Usage:
---------------------

*Example Usage:*

```ruby
require "sinatra"

post '/' do
  @@response = Twocheckout::ValidateResponse.purchase({:sid => 1817037, :secret => "tango", :order_number => params[:order_number], :total => params[:total], :key => params[:key]})
  @@response.inspect
end
```

*Example Response:*

```ruby
{
    :code => "PASS",
    :message => "Hash Matched"
}
```

Example INS Usage:
------------------

*Example Usage:*

```ruby
require "sinatra"

post '/' do
 @@response = Twocheckout::ValidateResponse.notification({:sale_id => params[:sale_id], :vendor_id => 1817037, :invoice_id => params[:invoice_id], :secret => "tango", :md5_hash => params[:md5_hash]})
 @@response.inspect
end
```

*Example Response:*

```ruby
{
    :code => "PASS",
    :message => "Hash Matched"
}
```

Exceptions:
------------------

*Example Catch:*

Exceptions are thrown by if an error has returned. It is best to catch these exceptions so that they can be gracefully handled in your application.


```ruby
begin
  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
  last_invoice = sale.invoices.last
  last_lineitem = last_invoice.lineitems.last
  last_lineitem.stop_recurring!
rescue Exception => e
  puts e.message
end
```

*Example Exception:*

```ruby
"Lineitem is not scheduled to recur."
```

Full documentation for each binding is provided in the **[2Checkout Documentation](https://github.com/2checkout/2checkout-ruby/wiki)**.
