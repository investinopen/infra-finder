# frozen_string_literal: true

module Support
  module GQL
    module ExposesType
      extend ActiveSupport::Concern

      included do
        extend Dry::Core::ClassAttributes

        defines :graphql_object_type, type: Types::ExposableTypeOrUnset

        graphql_object_type Types::UNSET_TYPE
      end

      # @!attribute [r] graphql_object_type
      # @note This can be overridden at the instance level for unions / interfaces.
      # @return [Class(GraphQL::Schema::Object), Module(GraphQL::Schema::Interface)]
      def graphql_object_type = self.class.graphql_object_type

      module ClassMethods
        # Set the GraphQL type that represents an instance of this class in the API.
        # It can be a discrete object type **or** an interface.
        #
        # @param [Class(GraphQL::Schema::Object), Module(GraphQL::Schema::Interface)] object_type
        # @return [void]
        def expose_graphql!(object_type)
          graphql_object_type object_type
        end
      end
    end
  end
end
