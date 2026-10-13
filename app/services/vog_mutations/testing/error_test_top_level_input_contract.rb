# frozen_string_literal: true

module VOGMutations
  module Testing
    # @see Mutations::ErrorTest
    # @see Mutations::Implementations::ErrorTest
    # @see Types::ErrorTestTopLevelInputType
    class ErrorTestTopLevelInputContract < VOGMutations::Contract
      json do
        required(:name).filled(:string)
        optional(:nested).array(:hash, VOGMutations::Testing::ErrorTestNestedInputContract.schema)
      end

      rule(:nested).each(contract: VOGMutations::Testing::ErrorTestNestedInputContract)
    end
  end
end
