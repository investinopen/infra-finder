# frozen_string_literal: true

module VOGMutations
  module Halting
    # An error raised when a mutation is unauthorized.
    class Unauthorized < VOGMutations::Halting::Error; end
  end
end
