# frozen_string_literal: true

module SolutionProperties
  class LoadExisting < Support::SimpleServiceOperation
    service_klass SolutionProperties::ExistingLoader
  end
end
