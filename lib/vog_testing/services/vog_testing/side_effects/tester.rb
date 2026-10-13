# frozen_string_literal: true

module VOGTesting
  module SideEffects
    # @see VOGTesting::SideEffects::Build
    class Tester < Dry::Struct
      attribute :action, VOGTesting::Types::Callable
      attribute :effects, VOGTesting::Types::Array.optional
      attribute :expectation, VOGTesting::Types::Any.optional

      def has_expectation?
        !expectation.nil?
      end
    end
  end
end
