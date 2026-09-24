# frozen_string_literal: true

module Solutions
  # Check to see if any solutions have changed their claiming state and update them accordingly.
  class CheckClaimStates
    include Dry::Monads[:result]
    include QueryOperation

    QUERY = <<~SQL
    UPDATE solutions s SET claim_state = sdc.claim_state
    FROM solution_derived_claims sdc
    WHERE sdc.solution_id = s.id AND sdc.claim_state <> s.claim_state
    SQL

    def call
      changed = sql_update! QUERY

      Success changed
    end
  end
end
