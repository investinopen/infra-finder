# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approver
  class Approve < Support::SimpleServiceOperation
    with_matcher!

    service_klass SolutionIntakes::Approver
  end
end
