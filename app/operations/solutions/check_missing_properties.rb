# frozen_string_literal: true

module Solutions
  # Recheck which required properties a solution, draft, or intake is missing, and
  # persist the list if it changed.
  class CheckMissingProperties
    include Dry::Monads[:result, :do]

    # @param [Solution, SolutionDraft, SolutionIntake] record
    # @return [Dry::Monads::Success(Boolean)]
    def call(record)
      missing_properties = yield record.find_missing_properties

      record.assign_attributes(missing_properties:)

      if record.missing_properties_changed?
        record.update_columns(missing_properties:)

        Success true
      else
        Success false
      end
    end
  end
end
