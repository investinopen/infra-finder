# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {SolutionIntake}.
    class SolutionIntakes < Filtering::FilterScope[SolutionIntake]
      has_name_search!

      simple_state_filter! :solution_intake_states do |arg|
        arg.description "Filter to intakes in one or more states."
      end

      simple_filter! :provider, :providers do |arg|
        arg.description "Filter to intakes for one or more providers."
      end

      boolean_scope! :missing_provider do |arg|
        arg.description "Filter to intakes that have no provider yet."
      end

      boolean_scope! :complete, falsey_scope: :incomplete do |arg|
        arg.description "Filter to intakes that are complete (true) or incomplete (false)."
      end

      timestamps!
    end
  end
end
