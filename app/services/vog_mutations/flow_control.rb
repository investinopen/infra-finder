# frozen_string_literal: true

module VOGMutations
  # Flow control utilities for VOG mutation implementations.
  module FlowControl
    extend ActiveSupport::Concern

    # @raise [VOGMutations::Halting::Invalid]
    # @return [void]
    def throw_invalid
      raise VOGMutations::Halting::Invalid
    end

    # @raise [VOGMutations::Halting::Unauthorized]
    # @return [void]
    def throw_unauthorized
      raise VOGMutations::Halting::Unauthorized
    end
  end
end
