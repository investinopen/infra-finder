# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approve
  class Approver < SolutionIntakes::StateHandler
    targets! :approved

    # @return [Boolean]
    attr_reader :invited

    # Fails with `:incomplete` unless the intake is complete and valid.
    #
    # @return [Dry::Monads::Result]
    def prepare
      return Failure[:incomplete, intake] unless intake.valid?(:complete)

      super
    end

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
