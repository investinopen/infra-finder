# frozen_string_literal: true

module VOG
  # Methods for detecting whether changes to a model are happening
  # within the context of a GraphQL Mutation
  #
  # The predicate to use in lifecycles is {#in_graphql_mutation?}.
  #
  # @see VOGMutations.with_active
  module ModelMutationSupport
    extend ActiveSupport::Concern

    # @return [Boolean]
    def graphql_mutation_active
      VOGMutations::Current.active
    end

    alias graphql_mutation_active? graphql_mutation_active

    # An attribute that simulates a GraphQL mutation being active for testing/console use.
    # It serves as a fallback for {#graphql_mutation_active?} in {#in_graphql_mutation?}.
    #
    # @return [Boolean]
    attr_accessor :pretend_graphql_mutation_active

    alias pretend_graphql_mutation_active? pretend_graphql_mutation_active
    alias pretending_graphql_mutation_active? pretend_graphql_mutation_active

    # This will either detect from the dry-effect or it will use {#pretend_graphql_mutation_active}
    def in_graphql_mutation?
      graphql_mutation_active? || pretend_graphql_mutation_active?
    end

    # @return [void]
    def with_active_mutation!(&)
      VOGMutations.with_active!(&)
    end
  end
end
