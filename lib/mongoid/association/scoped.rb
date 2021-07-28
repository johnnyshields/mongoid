# frozen_string_literal: true
# encoding: utf-8

module Mongoid
  module Association
    class Scoped
      VALID_TARGET_CLASSES = [
        Mongoid::Association::Referenced::BelongsTo,
        Mongoid::Association::Referenced::HasOne,
        Mongoid::Association::Referenced::HasMany,
        Mongoid::Association::Referenced::HasAndBelongsToMany
      ]

      attr_reader :name,
                  :target,
                  :scope

      # Initialize the scoped association.
      #
      # @param [ Class ] _class The class of the model who owns this association.
      # @param [ Symbol ] name The name of the new association.
      # @param [ Symbol ] target The target association to use as a base.
      # @param [ Proc, Symbol, Criteria ] scope The scope to apply to the new association.
      #
      # @since 7.0
      def initialize(_class, name, target, scope)
        @owner_class = _class
        @name = name
        @scope = scope
        @target = _class.relations[target]
        unless @target && @target.class.in?(VALID_TARGET_CLASSES)
          raise Errors::InvalidAssociationScope.new(@owner_class, name, target)
        end
      end

      def setup!
        setup_instance_methods!
        self
      end

      # Setup the instance methods on the class having this association type.
      #
      # @return [ self ]
      #
      # @since 7.0
      def setup_instance_methods!
        define_getter!
        define_ids_getter! if cloned_target.is_a?(Mongoid::Association::Referenced::HasMany)
        define_existence_check!
        self
      end

      ruby2_keywords def method_missing(name, *args, &block)
        cloned_target.send(name, *args, &block)
      end

      ruby2_keywords def respond_to_missing?(name, *args)
        cloned_target.respond_to?(name, *args)
      end
      
      private

      def cloned_target
        @cloned_target ||= @target.clone.tap do |rel|
          rel.relation_class # memoize class name
          rel.instance_variable_set(:@name, name)
          rel.instance_variable_set(:@options, rel.options.merge(scope: scope))
        end
      end
    end
  end
end
