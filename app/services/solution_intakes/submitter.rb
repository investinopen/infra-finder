# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Submit
  class Submitter < SolutionIntakes::StateHandler
    targets! :in_review

    def post_transition
      yield notify!

      super
    end

    wrapped_hook! def notify
      SolutionIntakes::SubmittedNotifier.with(solution_intake:, user:).deliver_later

      super
    end
  end
end
