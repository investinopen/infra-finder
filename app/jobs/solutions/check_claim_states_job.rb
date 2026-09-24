# frozen_string_literal: true

module Solutions
  # A job run at an interval that monitors solutions for changes in claiming.
  #
  # @see Solutions::CheckClaimStates
  class CheckClaimStatesJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      call_operation!("solutions.check_claim_states")
    end
  end
end
