# frozen_string_literal: true

module VOGMutations
  # The `current` context for VOG mutations.
  #
  # @see VOGMutations.with_active!
  # @see VOGMutations::ReadsCurrentMutation
  # @see VOGMutations::Implementation
  class Current < ActiveSupport::CurrentAttributes
    attribute :active, default: proc { false }
    attribute :response, default: proc { VOGMutations::Response.new }
    attribute :result
    attribute :state, default: proc { VOGMutations::State.new }
  end
end
