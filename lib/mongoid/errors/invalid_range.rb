# frozen_string_literal: true

module Mongoid
  module Errors

    # This exception is raised when a Range is attempted to be serialized
    # in an unsupported format.
    class InvalidRange < MongoidError

      # Create the new invalid range error.
      #
      # @example Create the new invalid range error.
      #   InvalidTime.new(3..)
      #
      # @param [ Range ] value The range that was attempted.
      def initialize(value)
        super(compose_message("invalid_time", { value: value }))
      end
    end
  end
end
