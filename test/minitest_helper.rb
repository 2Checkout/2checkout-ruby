require "minitest/autorun"
require "twocheckout"

Twocheckout::API.credentials = {
    :username => 'CREDENTIALS HERE',
    :password => 'CREDENTIALS HERE',
    :seller_id => 'CREDENTIALS HERE',
    :private_key => 'CREDENTIALS HERE',
}