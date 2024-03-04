# frozen_string_literal: true

module Utility
  # Camelize a hash for use in the frontend.
  #
  # @note This is a non-monadic operation.
  class CamelizeHash
    extend Dry::Core::Cache

    include Dry::Monads[:result]
    include Common::Deps[
      inflector: "inflector",
    ]

    # @param [Hash] value
    # @raise [TypeError] provide a hash or else
    # @return [ActiveSupport::HashWithIndifferentAccess]
    # @ret
    def call(value)
      raise TypeError unless value.kind_of?(Hash)

      value.with_indifferent_access.deep_transform_keys do |key|
        case key
        when String, Symbol
          fetch_or_store key do
            inflector.camelize(key, :lower)
          end
        else
          # :nocov:
          raise TypeError, "invalid key: #{key.inspect}"
          # :nocov:
        end
      end
    end
  end
end
