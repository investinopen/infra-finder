# frozen_string_literal: true

module SolutionProperties
  module Admin
    # @see SolutionProperties::Admin::TabParser
    class ParseTabs < Support::SimpleServiceOperation
      service_klass SolutionProperties::Admin::TabParser
    end
  end
end
