require "pp"

module Twocheckout
  class HashObject

    def initialize(hash)
      @hash = hash
    end

    def method_missing(name)
      name = name.to_s
      if @hash.key? name
        result = @hash[name]
        if result.is_a?(Hash)
          result = HashObject.new(result)
          @hash[name] = result
        end
        if result.is_a?(Array)
          new_array = []
          result.each do |item|
            new_item = item.is_a?(Hash) ? HashObject.new(item) : item
            new_array << new_item
          end
          new_array.freeze
          result = new_array
          @hash[name] = result
        end
        return result
      end
      super.method_missing name
    end

    def inspect
      "#<#{self.class.name}:#{self._key}> #{pp @hash}"
    end

    protected

    def _key
      self.object_id.to_s
    end

  end
end
