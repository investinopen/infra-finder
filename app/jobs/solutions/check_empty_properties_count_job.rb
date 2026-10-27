# frozen_string_literal: true

module Solutions
  class CheckEmptyPropertiesCountJob < ApplicationJob
    queue_as :maintenance

    # @param [Solution] solution
    # @return [void]
    def perform(solution)
      call_operation!("solutions.check_empty_properties_count", solution)
    end
  end
end
