# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Reject
  class Rejector < SolutionIntakes::StateHandler
    targets! :rejected
  end
end
