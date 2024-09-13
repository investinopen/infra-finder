# frozen_string_literal: true

module Solutions
  class CheckFlagsJob < ApplicationJob
    queue_as :maintenance

    # @param [Solution] solution
    # @return [void]
    def perform(solution)
      call_operation!("solutions.check_flags", solution)
    end
  end
end
