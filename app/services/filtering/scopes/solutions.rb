# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {Solution}.
    class Solutions < Filtering::FilterScope[Solution]
      has_name_search!

      argument! :editable_by_viewer, :bool do |arg|
        arg.description "Filter to the solutions the viewer can edit. Admins can edit every solution."
      end

      simple_filter! :publication, :publications do |arg|
        arg.description "Filter to solutions with one or more publication statuses."
      end

      simple_filter! :claim_state, :solution_claim_states do |arg|
        arg.description "Filter to solutions in one or more claim states."
      end

      simple_filter! :provider, :providers do |arg|
        arg.description "Filter to solutions from one or more providers."
      end

      simple_scope_filter! :solution_category, :solution_categories, scope_name: :with_solution_categories do |arg|
        arg.description "Filter to solutions in one or more solution categories."
      end

      boolean_scope! :with_pending_drafts do |arg|
        arg.description "Filter to solutions with a pending draft."
      end

      boolean_scope! :with_reviewable_drafts do |arg|
        arg.description "Filter to solutions with a draft in review."
      end

      integer_match! :empty_properties_count

      timestamps!

      after_build def apply_editable_by_viewer!
        augment_scope! do |scope|
          scope.with_editor_access_for(current_user) if editable_by_viewer && !has_any_admin_access?
        end
      end
    end
  end
end
