# frozen_string_literal: true

module Solutions
  # Rechecks completeness everywhere, since the required properties can change
  # without the records themselves being saved.
  class CheckAllMissingPropertiesJob < ApplicationJob
    queue_as :maintenance

    queue_with_priority 100

    # @return [void]
    def perform
      [::Solution, ::SolutionDraft, ::SolutionIntake].each do |model|
        model.find_each do |record|
          Solutions::CheckMissingPropertiesJob.perform_later record
        end
      end
    end
  end
end
