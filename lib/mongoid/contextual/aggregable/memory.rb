# frozen_string_literal: true

module Mongoid
  module Contextual
    module Aggregable
      # Contains behavior for aggregating values in memory.
      module Memory

        # Get all the aggregate values for the provided field.
        # Provided for interface consistency with Aggregable::Mongo.
        #
        # @param [ String, Symbol ] field The field name.
        #
        # @return [ Hash ] A Hash containing the aggregate values.
        #   If no documents are present, then returned Hash will have
        #   count, sum of 0 and max, min, avg of nil.
        def aggregates(field)
          %w(count sum avg min max).each_with_object({}) do |method, hash|
            hash[method] = send(method, field)
          end
        end

        # Get the average value of the provided field.
        #
        # @example Get the average of a single field.
        #   aggregable.avg(:likes)
        #
        # @param [ Symbol ] field The field to average.
        #
        # @return [ Float ] The average.
        def avg(field)
          total = count {|doc| doc.send(field).numeric? }
          return nil unless total > 0

          sum(field).to_f / total.to_f
        end

        # Get the max value of the provided field. If provided a block, will
        # return the Document with the greatest value for the field, in
        # accordance with Ruby's enumerable API.
        #
        # @example Get the max of a single field.
        #   aggregable.max(:likes)
        #
        # @example Get the document with the max value.
        #   aggregable.max do |a, b|
        #     a.likes <=> b.likes
        #   end
        #
        # @param [ Symbol ] field The field to max.
        #
        # @return [ Float, Document ] The max value or document with the max
        #   value.
        def max(field = nil)
          return super() if block_given?

          aggregate_by(field, :max_by)
        end

        # Get the min value of the provided field. If provided a block, will
        # return the Document with the smallest value for the field, in
        # accordance with Ruby's enumerable API.
        #
        # @example Get the min of a single field.
        #   aggregable.min(:likes)
        #
        # @example Get the document with the min value.
        #   aggregable.min do |a, b|
        #     a.likes <=> b.likes
        #   end
        #
        # @param [ Symbol ] field The field to min.
        #
        # @return [ Float, Document ] The min value or document with the min
        #   value.
        def min(field = nil)
          return super() if block_given?

          aggregate_by(field, :min_by)
        end

        # Get the sum value of the provided field. If provided a block, will
        # return the sum in accordance with Ruby's enumerable API.
        #
        # @example Get the sum of a single field.
        #   aggregable.sum(:likes)
        #
        # @example Get the sum for the provided block.
        #   aggregable.sum(&:likes)
        #
        # @param [ Symbol ] field The field to sum.
        #
        # @return [ Float ] The sum value.
        def sum(field = nil)
          return super() if block_given?
          return 0 unless count > 0

          super(0) {|doc| __coerce_numeric(doc.public_send(field)) }
        end

        private

        # Aggregate by the provided field and method.
        #
        # @api private
        #
        # @example Aggregate by the field and method.
        #   aggregable.aggregate_by(:likes, :min_by)
        #
        # @param [ Symbol ] field The field to aggregate on.
        # @param [ Symbol ] method The method (min_by or max_by).
        #
        # @return [ Integer ] The aggregate.
        def aggregate_by(field, method)
          return nil unless count > 0

          default = method == :min_by ? Float::INFINITY : 0
          obj = send(method) {|doc| __coerce_numeric(doc.public_send(field), default) }
          __coerce_numeric(obj.public_send(field), nil)
        end

        # Returns the given value if it is numeric, otherwise returns
        # a given default value. Strings will be coerced to either
        # Float or Integer depending on format.
        #
        # @api private
        #
        # @param [ Object ] value The value to return if numeric.
        # @param [ Integer, Float ] default The return value if not numeric.
        #
        # @return [ Integer, Float ] The coerced value.
        def __coerce_numeric(value, default = 0)
          if !value.numeric?
            default
          elsif value.is_a?(String)
            value.match(/[^\s\d]/) ? Float(value) : Integer(value)
          else
            value
          end
        end
      end
    end
  end
end
