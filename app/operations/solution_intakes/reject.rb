# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Rejector
  class Reject < Support::SimpleServiceOperation
    with_matcher!

    service_klass SolutionIntakes::Rejector
  end
end
