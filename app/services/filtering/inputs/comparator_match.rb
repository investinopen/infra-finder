# frozen_string_literal: true

module Filtering
  module Inputs
    # The base class for building comparator match input structs.
    #
    # @abstract
    class ComparatorMatch < Filtering::Inputs::AbstractMatch
      include ArelHelpers

      # The available comparators.
      COMPARATORS = %i[eq lt lteq gt gteq not_eq].freeze

      # @api private
      # @return [{ Symbol => Object }]
      attr_reader :comparators

      delegate :blank?, to: :comparators

      def initialize(...)
        super

        @comparators = attributes.compact
      end

      # @param [Arel::Attribute] attribute
      # @return [Arel::Expressions]
      def call(attribute)
        return if blank?

        expressions = comparators.map do |(cmp, value)|
          attribute.public_send(cmp, value)
        end

        arel_andify expressions
      end

      # @param [Symbol] cmp
      def has?(cmp) = comparators.key? cmp

      alias has_comparator? has?

      class << self
        protected

        # @return [void]
        def on_inherit!
          define_comparator_attributes_for! base_type

          input_object input_object_for(type_key)
        end

        # @param [:date, :float, :integer, :time] type_key
        # @return [Class(::Types::FilterMatchInputObject)]
        def input_object_for(type_key) = "::Types::FilterMatch#{type_key.to_s.classify}InputType".constantize

        # Decorate the subclass with comparator attributes.
        #
        # @param [Dry::Types::Type] type
        # @return [void]
        def define_comparator_attributes_for!(type)
          COMPARATORS.each do |comparator|
            attribute? comparator, type.optional
          end
        end
      end
    end
  end
end
