# frozen_string_literal: true

module Mongoid

  # Utility module which helps in
  #
  module FieldCache

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def database_field_name

    def get(*keys)
      keys.

      segment, remaining = key.split('.', 2)
      value = doc[segment]
      if remaining && value.is_a?(Hash)
        extract_nested_values(value.values.first, remaining)
      elsif remaining && value.is_a?(Array)
        value.map {|i| extract_nested_values(i, remaining) }
      else
        # raise() if remaining
        value
      end

      klass.database_field_name(f)
    end

    def get_field_object_map(*keys)
      keys.each_with_object({}) do |key, hash|
        obj = get_field_object(key)
        hash[key] = obj if obj
      end
    end

    def get_field_object(key)

    end




  end
end
