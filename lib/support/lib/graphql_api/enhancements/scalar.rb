# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      # @note `include` this on `Types::BaseScalar`.
      module Scalar
        extend ActiveSupport::Concern

        included do
          extend Dry::Core::ClassAttributes
        end

        module ClassMethods
          # Set up a scalar to wrap around a dry-type for validation.
          #
          # @param [Dry::Types::Type] type
          # @return [void]
          def wraps_dry_type!(type)
            include Support::GraphQLAPI::DryScalar

            dry_type type
          end
        end
      end
    end
  end
end
