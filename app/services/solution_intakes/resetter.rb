# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Reset
  class Resetter < SolutionIntakes::StateHandler
    targets! :pending
  end
end
