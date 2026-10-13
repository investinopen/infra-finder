# frozen_string_literal: true

module Support
  module GraphQLAPI
    # A synchronous dataloader for GraphQL queries.
    #
    # @see https://graphql-ruby.org/dataloader/dataloader
    class SynchronousDataloader < GraphQL::Dataloader
      self.default_fiber_limit = nil

      self.default_nonblocking = false
    end
  end
end
