# frozen_string_literal: true

module Solutions
  class CheckFlags
    include Dry::Monads[:result, :do]

    # @param [Solution] solution
    # @return [Dry::Monads::Success(Boolean)]
    def call(solution)
      flags = yield solution.calculate_flags

      solution.assign_attributes(flags:)

      if solution.flags_changed?
        solution.update_columns(flags:)

        Success true
      else
        Success false
      end
    end
  end
end
