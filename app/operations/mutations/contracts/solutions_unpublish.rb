# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionsUnpublish
    # @see Mutations::Implementations::SolutionsUnpublish
    class SolutionsUnpublish < VOGMutations::Contract
      json do
        required(:solutions).filled(:solutions)
      end
    end
  end
end
