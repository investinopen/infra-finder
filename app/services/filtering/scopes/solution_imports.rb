# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {SolutionImport}.
    class SolutionImports < Filtering::FilterScope[SolutionImport]
      simple_state_filter! :solution_import_states do |arg|
        arg.description "Filter to imports in one or more states."
      end

      simple_filter! :strategy, :solution_import_strategies do |arg|
        arg.description "Filter to imports using one or more strategies."
      end

      simple_filter! :user, :users do |arg|
        arg.description "Filter to imports started by one or more users."
      end

      timestamps!
    end
  end
end
