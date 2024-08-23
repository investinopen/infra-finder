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

  controller do
    include SolutionProperties::Admin::TrackForm
  end

  filter :name

  filter :solution_categories_id_in, as: :select, multiple: true, label: "Solution Categories (Any)",
    collection: SolutionCategory.for_filter_collection
  filter :licenses_id_in, as: :select, multiple: true, label: "Licenses (Any)",
    collection: License.for_filter_collection
  filter :user_contributions_id_in, as: :select, multiple: true, label: "User Contributions (Any)",
    collection: UserContribution.for_filter_collection

  filter :provider, include_blank: true, collection: Provider.for_filter_collection
  filter :board_structure, include_blank: true, collection: BoardStructure.for_filter_collection
  filter :business_form, include_blank: true, collection: BusinessForm.for_filter_collection
  filter :community_governance, include_blank: true, collection: CommunityGovernance.for_filter_collection
  filter :hosting_strategy, include_blank: true, collection: HostingStrategy.for_filter_collection
  filter :maintenance_statuses, include_blank: true, collection: MaintenanceStatus.for_filter_collection
  filter :primacy_funding_sourcees, include_blank: true, collection: PrimaryFundingSource.for_filter_collection
  filter :readiness_levels, include_blank: true, collection: ReadinessLevel.for_filter_collection

  scope :all

  scope :with_reviewable_drafts

  scope :published

  scope :unpublished

  config.per_page = 100

  config.sort_order = "name_asc"

  index download_links: proc { current_user.has_any_admin_access? && %i[csv] } do
    selectable_column

    column :name
    column :solution_categories
    column :provider
    column :published, sortable: false do |r|
      r.published?
    end
    column :updated_at

    actions do |solution|
      br
      item "Start Draft", create_draft_admin_solution_path(solution), method: :put
      br
      item "View Drafts", admin_solution_solution_drafts_path(solution)
      if current_user.has_any_admin_access?
        br
        item "Manage Access", admin_provider_provider_editor_assignments_path(solution.provider)
      end
    end
  end

  form partial: "form"

  show title: -> { _1.name.html_safe } do
    tabs do
      tab :core do
        attributes_table do
          row :provider

          render "admin/solutions/shared_show_core_attributes", context: self

          row :publication do |r|
            status_tag r.publication
          end

          row :published_at
          row :created_at
          row :updated_at
        end
      end

      render "admin/solutions/shared_show_tabs", context: self
    end

    active_admin_comments_for(resource)
  end

  action_item :view_on_site, only: :show do
    if resource.published?
      link_to "View on Site", solution_path(solution), target: "_blank", rel: "noopener"
    else
      link_to "View on Site (Unpublished)", ?#, style: "text-decoration: line-through;"
    end
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

  batch_action :destroy, false

  batch_action :publish_all, if: proc { authorized?(:publish_all, Solution) } do |ids|
    authorize :publish_all, policy_class: SolutionPolicy

    count = Solution.where(id: ids).publish_all!

    redirect_to admin_solutions_path, notice: t(".published", count:)
  rescue Pundit::NotAuthorizedError
    head :forbidden
  end

  batch_action :unpublish_all, if: proc { authorized?(:unpublish_all, Solution) } do |ids|
    authorize :unpublish_all, policy_class: SolutionPolicy

    count = Solution.where(id: ids).unpublish_all!

    redirect_to admin_solutions_path, notice: t(".unpublished", count:)
  rescue Pundit::NotAuthorizedError
    head :forbidden
  end

  csv force_quotes: true do
    SolutionInterface.private_csv!(self)
  end

  collection_action :fetch_public, method: :get, format: :csv do
    authorize :fetch_public, policy_class: SolutionPolicy

    headers["Content-Type"] = "text/csv; charset=utf-8" # In Rails 5 it's set to HTML??
    headers["Content-Disposition"] = ContentDisposition.attachment(csv_filename(for_public: true))

    builder_proc = SolutionInterface.public_csv_builder.method(:build).to_proc.curry[self]

    stream_resource &builder_proc
  rescue Pundit::NotAuthorizedError
    redirect_to root_path
  end

  sidebar :downloads, only: :index, if: proc { current_user.has_any_admin_access? } do
    link_to "Download Public CSV", fetch_public_admin_solutions_url(format: :csv)
  end

  controller do
    def csv_filename(for_public: false)
      prefix = for_public ? "public" : "internal-use"

      base = [prefix, "infra-finder-data-export", Date.current].join(?-)

      "#{base}.csv"
    end
  end
end
