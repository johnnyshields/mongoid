# frozen_string_literal: true

module Mongoid
  class SymbolizedIndifferentHash < ::ActiveSupport::HashWithIndifferentAccess

    # Overrides which mirror HashWithIndifferentAccess behavior
    undef :stringify_keys!
    undef :deep_stringify_keys!
    def stringify_keys; to_hash.stringify_keys! end
    def deep_stringify_keys; to_hash.deep_stringify_keys! end
    def symbolize_keys!; self end
    def deep_symbolize_keys!; self end
    def symbolize_keys; dup end
    def deep_symbolize_keys; dup end

    class << self
      def demongoize(object)
        return if object.nil?

        self.new(object)
      end

      def mongoize(object)
        return if object.nil?

        object.stringify_keys
      end

      # @api private
      def evolve(object)
        mongoize(object)
      end
    end

    private

    def convert_key(key)
      key.kind_of?(String) ? key.to_sym : key
    end
  end
end
