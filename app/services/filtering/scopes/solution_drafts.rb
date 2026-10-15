# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {SolutionDraft}.
    class SolutionDrafts < Filtering::FilterScope[SolutionDraft]
      simple_state_filter! :solution_draft_states do |arg|
        arg.description "Filter to drafts in one or more states."
      end

      simple_filter! :solution, :solutions do |arg|
        arg.description "Filter to drafts of one or more solutions."
      end

      simple_filter! :user, :users do |arg|
        arg.description "Filter to drafts created by one or more users."
      end

      timestamps!
    end
  end
end
