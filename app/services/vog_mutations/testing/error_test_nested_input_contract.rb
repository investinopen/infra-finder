# frozen_string_literal: true

module VOGMutations
  module Testing
    # @see Mutations::ErrorTest
    # @see Mutations::Implementations::ErrorTest
    # @see Types::ErrorTestNestedInputType
    class ErrorTestNestedInputContract < VOGMutations::Contract
      json do
        required(:user).value(:user)
        required(:detail).filled(:string)
      end

      rule(:detail) do
        key(:user).failure("must be referenced in detail") unless value.include?(values[:user].id)
      end
    end
  end
end
