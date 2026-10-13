# frozen_string_literal: true

module VOGTesting
  module SideEffects
    class Build
      # @return [VOGTesting::SideEffects::Tester]
      def call
        set_up!

        yield self if block_given?

        raise "must have at least one effect to test" if @effects.blank?
        raise "must have set an action" if @action.blank?

        expectation = @effects.reduce(&:and)

        attrs = {
          action: @action,
          effects: @effects.presence,
          expectation:,
        }

        VOGTesting::SideEffects::Tester.new attrs
      ensure
        set_up!
      end

      # @!group DSL Methods

      def action!(&action)
        raise "must provide an action block" unless block_given?

        @action = action
      end

      def effect!(matcher)
        @effects << matcher
      end

      # @!endgroup DSL Methods

      private

      # @return [void]
      def set_up!
        @effects = []
      end
    end
  end
end
