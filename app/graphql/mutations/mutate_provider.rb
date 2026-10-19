# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::ProviderCreate
  # @see Mutations::ProviderUpdate
  class MutateProvider < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `providerCreate` and `providerUpdate`.
    TEXT

    field :provider, Types::ProviderType, null: true do
      description <<~TEXT
      The newly-modified provider, if successful.
      TEXT
    end

    argument :name, String, required: false do
      description "The provider's name."
    end

    argument :url, String, required: false do
      description "The provider's website."
    end
  end
end
