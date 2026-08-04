# frozen_string_literal: true

module SolutionProperties
  # @see SolutionProperties::StrongParamsBuilder
  class BuildStrongParams < Support::SimpleServiceOperation
    service_klass SolutionProperties::StrongParamsBuilder
  end
end
