# frozen_string_literal: true

module Solutions
  class CheckMissingPropertiesJob < ApplicationJob
    queue_as :maintenance

    # @param [Solution, SolutionDraft, SolutionIntake] record
    # @return [void]
    def perform(record)
      call_operation!("solutions.check_missing_properties", record)
    end
  end
end
