# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approve
  class Approver < SolutionIntakes::StateHandler
    targets! :approved

    # @return [Boolean]
    attr_reader :invited

    def pre_transition
      yield intake.assign

      super
    end

    def post_transition
      @invited = yield intake.try_inviting

      yield notify!

      super
    end

    wrapped_hook! def notify
      SolutionIntakes::ApprovedNotifier.with(invited:, solution_intake:, solution:, user:).deliver_later

      super
    end
  end
end
