# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionsPublish
    # @see Mutations::Implementations::SolutionsPublish
    class SolutionsPublish < VOGMutations::Contract
      json do
        required(:solutions).filled(:solutions)
      end
    end
  end
end
