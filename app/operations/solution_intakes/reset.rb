# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Resetter
  class Reset < Support::SimpleServiceOperation
    service_klass SolutionIntakes::Resetter
  end
end
