# frozen_string_literal: true

module VOGMutations
  module Halting
    # An error raised when a mutation is invalid.
    class Invalid < VOGMutations::Halting::Error; end
  end
end
