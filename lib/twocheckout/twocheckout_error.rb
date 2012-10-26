module Twocheckout
  class TwocheckoutError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def retrieve
      if @message.is_a?(Hash)
        @message = JSON.generate(@message)
        "#{@message}"
      else
        "#{@message}"
      end
    end
  end
end