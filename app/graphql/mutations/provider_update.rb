# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ProviderUpdate
  class ProviderUpdate < Mutations::MutateProvider
    description <<~TEXT
    Update a single `Provider` record.
    TEXT

    argument :provider_id, ID, loads: Types::ProviderType, required: true do
      description <<~TEXT
      The provider to update.
      TEXT
    end

    performs_operation! "mutations.implementations.provider_update"
  end
end
