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
        redirect_to admin_solution_solution_draft_path(resource, draft), notice: t(".draft_created")
      end

      m.failure :pending_draft_exists do |_, draft|
        redirect_to admin_solution_solution_draft_path(resource, draft), alert: t(".pending_draft_exists")
      end

      m.failure do
        # :nocov:
        redirect_back fallback_location: admin_solutions_path, alert: I18n.t("api.errors.something_went_wrong")
        # :nocov:
      end
    end
  end

  filter :name

  filter :solution_categories, include_blank: true, collection: SolutionCategory.for_filter_collection
  filter :licenses, include_blank: true, collection: License.for_filter_collection
  filter :user_contributions, include_blank: true, collection: UserContribution.for_filter_collection

  filter :organization, include_blank: true, collection: Organization.for_filter_collection
  filter :board_structure, include_blank: true, collection: BoardStructure.for_filter_collection
  filter :business_form, include_blank: true, collection: BusinessForm.for_filter_collection
  filter :community_governance, include_blank: true, collection: CommunityGovernance.for_filter_collection
  filter :hosting_strategy, include_blank: true, collection: HostingStrategy.for_filter_collection
  filter :maintenance_status, include_blank: true, collection: MaintenanceStatus.for_filter_collection
  filter :primacy_funding_source, include_blank: true, collection: PrimaryFundingSource.for_filter_collection
  filter :readiness_level, include_blank: true, collection: ReadinessLevel.for_filter_collection

  scope :all

  scope :with_reviewable_drafts

  config.per_page = 100

  config.sort_order = "name_asc"

  index download_links: proc { current_user.has_any_admin_access? && %i[csv] } do
    selectable_column

    column :name
    column :solution_categories
    column :organization
    column :updated_at

    actions do |solution|
      br
      item "Start Draft", create_draft_admin_solution_path(solution), method: :put
      br
      item "View Drafts", admin_solution_solution_drafts_path(solution)
      if current_user.has_any_admin_access?
        br
        item "Manage Access", admin_solution_solution_editor_assignments_path(solution)
      end
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

  csv do
    column :id
    column :name
  end
end
