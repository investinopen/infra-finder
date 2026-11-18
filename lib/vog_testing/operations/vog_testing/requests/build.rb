# frozen_string_literal: true

module VOGTesting
  module Requests
    class Build
      include VOGTesting::Deps[:gql]

      # @return [VOGTesting::GQL::RequestTester]
      def call
        set_up!

        yield self if block_given?

        expectation = @effects.reduce(&:and) if @effects.any?

        attrs = {
          data: @data,
          expectation:,
          effects: @effects.presence,
          top_level_errors: @top_level_errors,
        }

        VOGTesting::GQL::RequestTester.new attrs
      ensure
        set_up!
      end

      # @!group DSL Methods

      def effect!(matcher)
        @effects << matcher
      end

      def data!(value)
        @data = value
      end

      # @return [Array<Hash>]
      def top_level_errors!(value)
        @top_level_errors ||= []
        @top_level_errors.concat(value)
      end

      alias errors! top_level_errors!

      def invalid_one_of!(...)
        top_level_errors! @gql.top_level.invalid_one_of(...)
      end

      def invalid_enum_value!(...)
        top_level_errors! @gql.top_level.invalid_enum_value(...)
      end

      def non_null!(...)
        top_level_errors! @gql.top_level.non_null(...)
      end

      def unauthorized!
        top_level_errors! @gql.top_level.unauthorized
      end

      # @!endgroup DSL Methods

      private

      # @return [void]
      def set_up!
        @effects = []

        @data = nil

        @top_level_errors = nil
      end
    end
  end
end
