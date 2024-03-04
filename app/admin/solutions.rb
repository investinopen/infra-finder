# frozen_string_literal: true

ActiveAdmin.register Solution do
  menu priority: 1

  scope_to :current_user, association_method: :assigned_solutions, unless: proc { current_user.has_any_admin_access? }

  permit_params do
    Solution.build_strong_params(current_user:, draft: false)
  end

  member_action :create_draft, method: :put do
    resource.create_draft(user: current_user) do |m|
      m.success do |draft|
        redirect_to admin_solution_solution_draft_path(resource, draft), notice: "Draft created."
      end

      m.failure :pending_draft_exists do |_, draft|
        redirect_to admin_solution_solution_draft_path(resource, draft), alert: "You have an existing pending draft."
      end

      m.failure do
        # :nocov:
        redirect_back fallback_location: admin_solutions_path, alert: I18n.t("api.errors.something_went_wrong")
        # :nocov:
      end
    end
  end

  filter :name

  filter :solution_categories, include_blank: true
  filter :licenses, include_blank: true
  filter :user_contributions, include_blank: true

  filter :organization, include_blank: true
  filter :board_structure, include_blank: true
  filter :business_form, include_blank: true
  filter :community_governance, include_blank: true
  filter :hosting_strategy, include_blank: true
  filter :maintenance_status, include_blank: true
  filter :primacy_funding_source, include_blank: true
  filter :readiness_level, include_blank: true

  scope :all

  scope :with_reviewable_drafts

  index do
    selectable_column

    column :name
    column :created_at

    actions do |solution|
      item "Start Draft", create_draft_admin_solution_path(solution), method: :put
      text_node "&nbsp;&nbsp;".html_safe
      item "Drafts", admin_solution_solution_drafts_path(solution)
      text_node "&nbsp;&nbsp;".html_safe
      item "Manage Access", admin_solution_solution_editor_assignments_path(solution)
    end
  end

  form partial: "form"

  show do
    tabs do
      tab :core do
        attributes_table do
          row :organization

          render "admin/solutions/shared_show_core_attributes", context: self

          row :created_at
          row :updated_at
        end
      end

      render "admin/solutions/shared_show_tabs", context: self
    end

    active_admin_comments_for(resource)
  end

  action_item :start_or_view_draft, only: :show, if: proc { authorized?(:create_draft, resource) } do
    if current_user.has_pending_draft_for?(resource)
      draft = current_user.pending_draft_for(resource)

      link_to "View Pending Draft", admin_solution_solution_draft_path(solution, draft)
    else
      link_to "Start Draft", create_draft_admin_solution_path(solution), method: :put
    end
  end

  action_item :view_all_drafts, only: :show, if: proc { current_user.has_any_admin_access? } do
    link_to "View All Drafts", admin_solution_solution_drafts_path(solution)
  end

  action_item :manage_access, only: :show, if: proc { current_user.has_any_admin_access? } do
    link_to "Manage Access", admin_solution_solution_editor_assignments_path(solution)
  end
end
