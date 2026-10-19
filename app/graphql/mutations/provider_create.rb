# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ProviderCreate
  class ProviderCreate < Mutations::MutateProvider
    description <<~TEXT
    Create a single `Provider` record.
    TEXT

    argument :name, String, required: true do
      description "The provider's name."
    end

    performs_operation! "mutations.implementations.provider_create"
  end
end
