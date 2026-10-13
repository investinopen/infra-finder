# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ErrorTest
    # @see Mutations::Implementations::ErrorTest
    class ErrorTest < VOGMutations::Contract
      json do
        required(:inputs).array(:hash, VOGMutations::Testing::ErrorTestTopLevelInputContract.schema)
      end

      rule(:inputs).each(contract: VOGMutations::Testing::ErrorTestTopLevelInputContract)
    end
  end
end
