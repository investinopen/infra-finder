# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {User}.
    class Users < Filtering::FilterScope[User]
      simple_scope_filter! :email, :string do |arg|
        arg.description "Look for an exact email match."
      end

      has_name_search!

      simple_scope_filter! :kind, :user_kinds do |arg|
        arg.description "Filter to users of one or more kinds."
      end

      time_match! :current_sign_in_at

      integer_match! :sign_in_count

      timestamps!
    end
  end
end
