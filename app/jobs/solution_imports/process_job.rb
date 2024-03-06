# frozen_string_literal: true

module SolutionImports
  # @see SolutionImport#process
  class ProcessJob < ApplicationJob
    queue_as :import

    # @return [void]
    def perform(solution_import)
      solution_import.process!
    end
  end
end
