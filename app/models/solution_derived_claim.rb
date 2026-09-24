# frozen_string_literal: true

class SolutionDerivedClaim < ApplicationRecord
  include View

  pg_enum! :claim_state, as: :solution_claim_state, allow_blank: false, default: "unclaimed"

  belongs_to_readonly :solution, inverse_of: :derived_claim
end
