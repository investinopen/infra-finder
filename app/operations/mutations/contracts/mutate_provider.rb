# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateProvider
    class MutateProvider < VOGMutations::Contract
      json do
        optional(:name).filled(:string)
        optional(:url).maybe(:string)
      end
    end
  end
end
