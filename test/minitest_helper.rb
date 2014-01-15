require "minitest/spec"
require "minitest/autorun"
require "twocheckout"

Twocheckout::API.credentials = {
    :username => 'APIuser1817037',
    :password => 'APIpass1817037',
    :seller_id => '532001',
    :private_key => '9999999'
}