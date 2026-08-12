# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::InvitationAttempter
  class TryInviting < Support::SimpleServiceOperation
    service_klass SolutionIntakes::InvitationAttempter
  end
end
