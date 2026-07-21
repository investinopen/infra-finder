# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Assigner
  class Assign < Support::SimpleServiceOperation
    service_klass SolutionIntakes::Assigner
  end
end
