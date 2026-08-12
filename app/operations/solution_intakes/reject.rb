# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Rejector
  class Reject < Support::SimpleServiceOperation
    service_klass SolutionIntakes::Rejector
  end
end
