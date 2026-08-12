# frozen_string_literal: true

module Events
  module DerivesData
    extend ActiveSupport::Concern

    include ::Events::Named

    included do
      before_validation :derive_data!
    end

    private

    # @return [void]
    def capture_event_name!
      self.name = event_name
    end

    # @return [void]
    def capture_record!
      handle_associated! record
    end

    # @return [void]
    def derive_data!
      capture_event_name!
      capture_record!
    end

    # @param [ActiveRecord::Base] input
    # @return [void]
    def handle_associated!(input)
      case input
      in Provider
        handle_provider!(input)
      in Solution
        handle_solution!(input)
      in SolutionDraft
        handle_solution_draft!(input)
      in SolutionIntake
        handle_solution_intake!(input)
      end
    end

    # @param [Provider] provider
    # @return [void]
    def handle_provider!(provider)
      self.provider = provider
    end

    # @param [Solution] solution
    # @return [void]
    def handle_solution!(solution)
      self.solution = solution

      handle_provider!(solution.provider)
    end

    # @param [SolutionDraft] solution_draft
    # @return [void]
    def handle_solution_draft!(solution_draft)
      self.solution_draft = solution_draft

      handle_solution!(solution_draft.solution)
    end

    # @param [SolutionIntake] solution_intake
    # @return [void]
    def handle_solution_intake!(solution_intake)
      self.solution_intake = solution_intake

      handle_provider!(solution_intake.provider)
    end
  end
end
