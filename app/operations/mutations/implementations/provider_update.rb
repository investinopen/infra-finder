# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ProviderUpdate
    class ProviderUpdate < VOGMutations::Implementation
      use_contract! :provider_update
      use_contract! :mutate_provider

      authorizes! :provider, with: :update?

      # @param [Provider] provider
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(provider:, **attrs)
        assign_attributes!(provider, **attrs)

        persist_model! provider, attach_to: :provider
      end
    end
  end
end
