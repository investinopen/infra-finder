# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {ProviderEditorAssignment}.
    class ProviderEditorAssignments < Filtering::FilterScope[ProviderEditorAssignment]
      simple_filter! :provider, :providers do |arg|
        arg.description "Filter to assignments for one or more providers."
      end

      simple_filter! :user, :users do |arg|
        arg.description "Filter to assignments for one or more users."
      end

      timestamps!
    end
  end
end
