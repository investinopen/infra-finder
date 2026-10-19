# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ProviderDestroy
    class ProviderDestroy < VOGMutations::Implementation
      use_contract! :provider_destroy

      authorizes! :provider, with: :destroy?

      # @param [Provider] provider
      # @return [void]
      def call(provider:)
        destroy_model! provider, auth: true
      end
    end
  end
end
