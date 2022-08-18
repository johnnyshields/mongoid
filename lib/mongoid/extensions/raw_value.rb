# frozen_string_literal: true

# Wrapper class used when a value cannot be casted in evolve method.
module Mongoid
  def RawValue(*args)
    RawValue.new(*args)
  end

  class RawValue

    attr_reader :raw_value

    def initialize(raw_value)
      @raw_value = raw_value
    end

    # Delegate all missing methods to the raw value.
    #
    # @param [ String, Symbol ] method_name The name of the method.
    # @param [ Array ] args The arguments passed to the method.
    ruby2_keywords def method_missing(method_name, *args, &block)
      raw_value.send(method_name, *args, &block)
    end

    # Delegate all missing methods to the raw value.
    #
    # @param [ String, Symbol ] method_name The name of the method.
    # @param [ true | false ] include_private Whether to check private methods.
    def respond_to_missing?(method_name, include_private = false)
      raw_value.respond_to?(method_name, include_private)
    end
  end
end
