# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Submitter
  class Submit < Support::SimpleServiceOperation
    with_matcher!

    service_klass SolutionIntakes::Submitter
  end
end
