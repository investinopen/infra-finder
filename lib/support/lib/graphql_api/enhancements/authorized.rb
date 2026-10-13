# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      # A module to be extended in any GraphQL type that wants to use ActionPolicy for authorization.
      module Authorized
        # @param [ApplicationRecord] object
        # @param [GraphQL::Query::Context] graphql_context
        # @raise [ActionPolicy::NotFound] if a policy cannot be found for the object
        def authorized?(object, graphql_context)
          context = { user: graphql_context[:current_user], }

          if graphql_context[:current_object].kind_of?(::Types::MutationType)
            # This is an object being loaded as an argument in a mutation.
            # If we can't even read it, throw an exception that GQL will catch and skip the mutation entirely.
            return authorize!(object, to: :read_for_mutation?, context:)
          end

          allowed_to?(graphql_read_rule, object, context:)
        end

        # The policy rule that decides whether an object of this type can be read.
        #
        # @note An infra-finder addition: SJ always uses `show?`. Some policies keep
        #   `show?` for ActiveAdmin and grant API reads through another rule.
        # @param [Symbol, nil] rule sets the rule when provided
        # @return [Symbol]
        def graphql_read_rule(rule = nil)
          @graphql_read_rule = rule if rule

          @graphql_read_rule || (superclass.respond_to?(:graphql_read_rule) ? superclass.graphql_read_rule : :show?)
        end
      end
    end
  end
end
