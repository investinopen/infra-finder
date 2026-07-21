# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approver
  class Approve < Support::SimpleServiceOperation
    service_klass SolutionIntakes::Approver
  end
end
