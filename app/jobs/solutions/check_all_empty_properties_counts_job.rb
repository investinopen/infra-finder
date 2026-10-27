# frozen_string_literal: true

module Solutions
  class CheckAllEmptyPropertiesCountsJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    queue_with_priority 100

    # @param [String] cursor
    # @return [Enumerator]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Solution.all,
        cursor:
      )
    end

    # @param [Solution] solution
    def each_iteration(solution)
      Solutions::CheckEmptyPropertiesCountJob.perform_later solution
    end
  end
end
