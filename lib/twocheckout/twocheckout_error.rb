module Twocheckout
  class TwocheckoutError < StandardError
    attr_reader :message
    attr_reader :code

    def initialize(message, code = nil)
      @message = message
      @code = code
    end
  end
end
