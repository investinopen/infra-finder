# frozen_string_literal: true

module Solutions
  # Recount a solution's empty properties and persist the count if it changed.
  class CheckEmptyPropertiesCount
    include Dry::Monads[:result, :do]

    # @param [Solution] solution
    # @return [Dry::Monads::Success(Boolean)]
    def call(solution)
      empty_properties_count = yield solution.count_empty_properties

      solution.assign_attributes(empty_properties_count:)

      if solution.empty_properties_count_changed?
        solution.update_columns(empty_properties_count:)

        Success true
      else
        Success false
      end
    end
  end
end
