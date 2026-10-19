# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ProviderCreate
    class ProviderCreate < VOGMutations::Implementation
      use_contract! :provider_create
      use_contract! :mutate_provider

      authorizes! :provider, with: :create?

      # @param [Provider] provider
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(provider:, **attrs)
        assign_attributes!(provider, **attrs)

        persist_model! provider, attach_to: :provider
      end

      before_prepare def initialize_provider!
        args[:provider] = Provider.new
      end
    end
  end
end
