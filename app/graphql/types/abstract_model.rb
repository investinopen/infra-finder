# frozen_string_literal: true

module Types
  # @abstract The base object type used to define ActiveRecord-backed models
  #   throughout the schema. It includes relay node interface as well as
  #   our standardized fields for encoded slugs and timestamps.
  class AbstractModel < Types::BaseObject
    extend Support::GraphQLAPI::Enhancements::Authorized

    implements GraphQL::Types::Relay::Node
    implements ::Types::CommonPermissionsType
    implements ::Types::SluggableType
    implements ::Types::HasDefaultTimestampsType

    global_id_field :id

    class << self
      # Ensure that all object types that inherit from this
      # define their global id field.
      #
      # @api private
      # @param [Class<GraphQL::Schema::Object>] subclass
      # @return [void]
      def inherited(subclass)
        super

        subclass.global_id_field :id
      end
    end
  end
end
