# frozen_string_literal: true

module Types
  # @abstract A base object type used throughout the schema,
  #   mostly to define other base / abstract types.
  class AbstractObjectType < GraphQL::Schema::Object
    include Support::GraphQLAPI::Enhancements::AbstractObject

    include GraphQL::FragmentCache::Object

    def current_user_privileged?
      # simplecov:disable
      context[:current_user].try(:has_any_admin_access?)
      # simplecov:enable
    end
  end
end
