# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {Invitation}.
    class Invitations < Filtering::FilterScope[Invitation]
      simple_filter! :provider, :providers do |arg|
        arg.description "Filter to invitations for one or more providers."
      end

      simple_scope_filter! :email, :string do |arg|
        arg.description "Look for an exact email match."
      end

      simple_state_filter! :invitation_states do |arg|
        arg.description "Filter to invitations in one or more states."
      end

      timestamps!
    end
  end
end
