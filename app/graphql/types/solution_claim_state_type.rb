# frozen_string_literal: true

module Types
  # @see Solution#claim_state
  class SolutionClaimStateType < Types::BaseEnum
    description <<~TEXT
    Whether a provider has claimed a `Solution`.
    TEXT

    value "UNCLAIMED", value: "unclaimed" do
      description "No provider editor has claimed the solution."
    end

    value "CLAIMED", value: "claimed" do
      description "A provider editor has claimed the solution."
    end
  end
end
