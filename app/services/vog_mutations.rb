# frozen_string_literal: true

# The top-level module for VOG mutations.
#
# VOGMutations primarily operate through {VOGMutations::Implementation implementations}
# that are run within an {VOGMutations::Executor executor}. They track state via
# {VOGMutations::State state} and report results through {VOGMutations::Response responses}.
#
# Actual implementation details largely live under {Mutations} for defining and executing mutations.
module VOGMutations
  # A submodule for handling GraphQL arguments.
  module Arguments
  end

  # A submodule for handling attachment-related functionality
  module Attachments
  end

  # A submodule for encapsulating halting behavior
  # within a mutation's execution.
  module Halting
  end

  # A submodule for testing-related utilities that
  # are closely tied to VOG mutations.
  module Testing
  end

  class << self
    # Set the current context to active within the given block.
    # @see VOGMutations::Current
    # @see VOG::MutationModelSupport
    # @return [void]
    def with_active!(response: VOGMutations::Response.new, state: VOGMutations::State.new, &)
      VOGMutations::Current.set(active: true, response:, state:, &)
    end
  end
end
