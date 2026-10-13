# frozen_string_literal: true

# The top level module for GraphQL resolver implementations.
#
# Resolvers in this subsystem handle data fetching and pagination
# for GraphQL queries, providing a bridge between the GraphQL schema
# and the underlying data models.
#
# The main entry point is {Resolvers::AbstractResolver}, which provides
# common functionality for all resolvers including pagination, filtering,
# ordering, and authorization.
#
# @see Resolvers::AbstractResolver
module Resolvers
  # A submodule containing various enhancements and mixins
  # for GraphQL resolvers.
  module Enhancements
  end
end
