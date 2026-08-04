# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approve
  class Approver < SolutionIntakes::StateHandler
    targets! :approved

    def pre_transition
      yield intake.assign

      super
    end
  end
end
