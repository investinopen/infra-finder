# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ProviderDestroy
  class ProviderDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `Provider` record.
    TEXT

    argument :provider_id, ID, loads: Types::ProviderType, required: true do
      description <<~TEXT
      The provider to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.provider_destroy", destroy: true
  end
end
