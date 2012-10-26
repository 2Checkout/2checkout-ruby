require "minitest/spec"
require "minitest/autorun"
require "twocheckout"

#
# Sales
#
describe Twocheckout::Sale do
  before do
    Twocheckout::API.credentials = { :username => 'APIuser1817037', :password => 'APIpass1817037' }
  end

  #retrieve sale
  it "Sale retrieve returns sale" do
    sale = Twocheckout::Sale.find(:sale_id => 4786293822)
    assert_equal('4786293822', sale.sale_id)
  end

  #retrieve invoice
  it "Sale retrieve returns invoice" do
    invoice = Twocheckout::Sale.find({:invoice_id => 4786293831})
    assert_equal('4786293831', invoice.invoice_id)
  end

  #retrieve sale list
  it "Sale list returns list" do
    sale_list = Twocheckout::Sale.list({:pagesize => 5})
    assert_equal(5, sale_list.size)
  end

  #refund sale
  it "Refunding a refunded sale returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  sale.refund!({:comment => "test refund", :category => 1})
    rescue Exception => e
	  assert_equal("Invoice was already refunded.", e.message)
    end
  end

  #refund invoice
  it "Refunding a refunded invoice returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  invoice = sale.invoices.first
	  invoice.refund!({:comment => "test refund", :category => 1})
    rescue Exception => e
	  assert_equal("Invoice was already refunded.", e.message)
    end
  end

  #refund lineitem
  it "Refunding a refunded lineitem returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  first_invoice = sale.invoices.first
	  last_lineitem = first_invoice.lineitems.last
	  last_lineitem.refund!({:comment => "test refund", :category => 1})
    rescue Exception => e
	  assert_equal("This lineitem cannot be refunded.", e.message)
    end
  end

  #stop recurring lineitem
  it "Stopping a stopped recurring lineitem returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  result = sale.stop_recurring!
	  assert_equal(result, [])
    rescue Exception => e
	  assert_equal("Lineitem is not scheduled to recur.", e.message)
    end
  end

  #stop recurring sale
  it "Stopping a stopped recurring sale returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  last_invoice = sale.invoices.last
	  last_lineitem = last_invoice.lineitems.last
	  last_lineitem.stop_recurring!
    rescue Exception => e
	  assert_equal("Lineitem is not scheduled to recur.", e.message)
    end
  end

  #create comment
  it "Creates a sale comment" do
  	sale = Twocheckout::Sale.find(:sale_id => 4786293822)
    result = sale.comment({:sale_comment => "test"})
    assert_equal('Created comment successfully.', result['response_message'])
  end

  #mark shipped
  it "Shipping an intangible sale returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  sale.ship({:tracking_number => "123"})
    rescue Exception => e
	  assert_equal("Item not shippable.", e.message)
    end
  end

  #reauth
  it "Reauthorizing a pending sale returns exception" do
  	begin
	  sale = Twocheckout::Sale.find(:sale_id => 4786293822)
	  sale.reauth
    rescue Exception => e
	  assert_equal("Payment is already pending or deposited and cannot be reauthorized.", e.message)
    end
  end
end

#
# Products
#

describe Twocheckout::Product do
  before do
    Twocheckout::API.credentials = { :username => 'APIuser1817037', :password => 'APIpass1817037' }
  end

  # Product list
  it "Product list returns array of products" do
    product_list = Twocheckout::Product.list({ :pagesize => 5 })
	assert_equal(product_list.size, 5)
  end

  # Product CRUD
   it "Product create, find, update, delete is successful" do
   	# create
    new_product = Twocheckout::Product.create({:name => "test product", :price => 1.00})
	assert_equal("test product", new_product.name)
	# find
	product = Twocheckout::Product.find({:product_id => new_product.product_id})
	assert_equal(new_product.product_id, product.product_id)
	# update
	product = product.update({:name => "new name"})
	assert_equal("new name", product.name)
	# delete
	result = product.delete!
	assert_equal("Product successfully deleted.", result['response_message'])
  end
end

describe Twocheckout::Option do
  before do
    Twocheckout::API.credentials = { :username => 'APIuser1817037', :password => 'APIpass1817037' }
  end

  # Option list
  it "Option list returns array of options" do
    option_list = Twocheckout::Option.list({ :pagesize => 5 })
	assert_equal(5, option_list.size)
  end

  # Option CRUD
   it "Option create, find, update, delete is successful" do
   	# create
    new_option = Twocheckout::Option.create({:option_name => "test option", 
    	:option_value_name => "test option value", :option_value_surcharge => 1.00})
	assert_equal("test option", new_option.option_name)
	# find
	option = Twocheckout::Option.find({:option_id => new_option.option_id})
	assert_equal(new_option.option_id, option.option_id)
	# update
	option = option.update({:option_name => "new name"})
	assert_equal("new name", option.option_name)
	# delete
	result = option.delete!
	assert_equal("Option deleted successfully", result['response_message'])
  end
end

describe Twocheckout::Coupon do
  before do
    Twocheckout::API.credentials = { :username => 'APIuser1817037', :password => 'APIpass1817037' }
  end

  # Coupon list
  it "Coupon list returns array of coupons" do
    coupon_list = Twocheckout::Coupon.list({ :pagesize => 4 })
	assert_equal(4, coupon_list.size)
  end

  # Coupon CRUD
   it "Coupon create, find, update, delete is successful" do
   	# create
    new_coupon = Twocheckout::Coupon.create({:date_expire => "2020-01-01", 
    	:type => "shipping", :minimum_purchase => 1.00})
	assert_equal("2020-01-01", new_coupon.date_expire)
	# find
	coupon = Twocheckout::Coupon.find({:coupon_code => new_coupon.coupon_code})
	assert_equal(new_coupon.coupon_code, coupon.coupon_code)
	# update
	coupon = coupon.update({:date_expire => "2020-01-02"})
	assert_equal("2020-01-02", coupon.date_expire)
	# delete
	result = coupon.delete!
	assert_equal("Coupon successfully deleted.", result['response_message'])
  end
end

describe Twocheckout::ValidateResponse do
  #purchase
  it "Validates Purchase MD5 Hash" do
    result = Twocheckout::ValidateResponse.purchase({:sid => 1817037, :secret => "tango", :order_number => 4789848870, :total => 0.01,
                             :key => 'CDF3E502AA1597DD4401760783432337'})
    assert_equal('PASS', result[:code])
  end

  #notification
  it "Validates Notification MD5 Hash" do
    result = Twocheckout::ValidateResponse.notification({:sale_id => 4789848870, :vendor_id => 1817037, :invoice_id => 4789848879, :secret => "tango",
                             :md5_hash => '827220324C722873694758F38D8D3624'})
    assert_equal('PASS', result[:code])
  end
end

describe Twocheckout::Checkout do
  #submit
  it "Submit return a form + JS to submit" do
    form = Twocheckout::Checkout.submit({ 'sid' => '1817037', 'cart_order_id' => 'Example Sale', 'total' => '1.00'})
    @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/spurchase\" method=\"post\">\n" + 
    "<input type=\"hidden\" name=\"sid\" value=\"1817037\" />\n" +
    "<input type=\"hidden\" name=\"cart_order_id\" value=\"Example Sale\" />\n" +
    "<input type=\"hidden\" name=\"total\" value=\"1.00\" />\n" +
    "</form>\n" + 
    "<script type=\"text/javascript\">document.getElementById('2checkout').submit();</script>"
    assert_equal(form, @form)
  end

  #form
  it "Form returns a form" do
    form = Twocheckout::Checkout.form({ 'sid' => '1817037', 'cart_order_id' => 'Example Sale', 'total' => '1.00'})
    @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/spurchase\" method=\"post\">\n" +
    "<input type=\"hidden\" name=\"sid\" value=\"1817037\" />\n" +
    "<input type=\"hidden\" name=\"cart_order_id\" value=\"Example Sale\" />\n" +
    "<input type=\"hidden\" name=\"total\" value=\"1.00\" />\n" +
    "<input type=\"submit\" value=\"Proceed to Checkout\" />\n" +
    "</form>"
    assert_equal(form, @form)
  end

  #link
  it "Link returns a link" do
    link = Twocheckout::Checkout.link({ 'sid' => '1817037', 'cart_order_id' => 'Example Sale', 'total' => '1.00'})
    @link = "https://www.2checkout.com/checkout/spurchase?sid=1817037&cart_order_id=Example+Sale&total=1.00"
    assert_equal(link, @link)
  end
end