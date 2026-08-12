# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Submitter
  class Submit < Support::SimpleServiceOperation
    service_klass SolutionIntakes::Submitter
  end
end
