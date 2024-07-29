# frozen_string_literal: true

module SolutionProperties
  class Parse < Support::SimpleServiceOperation
    service_klass SolutionProperties::Parser
  end
end
