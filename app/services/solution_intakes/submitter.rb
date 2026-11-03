# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Submit
  class Submitter < SolutionIntakes::StateHandler
    targets! :in_review

    # Fails with `:incomplete` unless the intake is complete and valid.
    #
    # @return [Dry::Monads::Result]
    def prepare
      return Failure[:incomplete, intake] unless intake.valid?(:complete)

      super
    end

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
