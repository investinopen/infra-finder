# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::InvitationAttempter
  class TryInviting < Support::SimpleServiceOperation
    with_matcher!

    service_klass SolutionIntakes::InvitationAttempter
  end
end
