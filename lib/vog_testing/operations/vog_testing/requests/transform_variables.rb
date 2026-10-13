# frozen_string_literal: true

module VOGTesting
  module Requests
    class TransformVariables
      extend Dry::Core::Cache

      include UsesCommonInflector

      # @param [#to_h] hash
      # @return [{ String => Object }]
      def call(hash)
        fetch_or_store :transformed, hash do
          VOGTesting::Types::Coercible::Hash[hash].deep_transform_keys do |key|
            fetch_or_store key do
              inflector.camelize(key, false)
            end
          end
        end
      end
    end
  end
end
