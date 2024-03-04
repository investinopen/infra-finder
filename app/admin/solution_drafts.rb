# frozen_string_literal: true

ActiveAdmin.register SolutionDraft do
  belongs_to :solution

  actions :all, except: %i[new create]

  permit_params do
    SolutionDraft.build_strong_params(current_user:, draft: true)
  end

  controller do
    def handle_simple_draft_operation!(operation_name, notice:, alert: I18n.t("api.errors.something_went_wrong"))
      resource.public_send(operation_name) do |m|
        m.success do
          redirect_to(admin_solution_solution_draft_path(resource.solution, resource), notice:)
        end

        m.failure do
          # :nocov:
          redirect_to(admin_solution_solution_drafts_path(resource.solution), alert:)
          # :nocov:
        end
      end
    end
  end

  member_action :request_review, method: :put do
    handle_simple_draft_operation!(:request_review, notice: "Draft will be reviewed by admins")
  end

  member_action :request_revision, method: :put do
    handle_simple_draft_operation!(:request_revision, notice: "Revision requested")
  end

  member_action :approve, method: :put do
    handle_simple_draft_operation!(:approve, notice: "Changes approved and applied to the solution")
  end

  member_action :reject, method: :put do
    handle_simple_draft_operation!(:reject, notice: "Changes rejected and locked from further editing.")
  end

  filter :user, include_blank: true

  scope :all
  scope :pending
  scope :in_review
  scope :approved
  scope :rejected

  index do
    selectable_column

    column :name
    column :user
    column :current_state do |r|
      status_tag r.current_state
    end
    column :created_at
    column :updated_at

    actions
  end

  form partial: "form"

  show do
    tabs do
      tab :core do
        attributes_table do
          row :current_state do |draft|
            status_tag draft.current_state
          end

          row :solution
          row :organization
          row :user

          render "admin/solutions/shared_show_core_attributes", context: self

          row :created_at
          row :updated_at
        end

        panel "Pending Changes" do
          para <<~TEXT.html_safe
          The following is a brief overview of the changes in this draft (if any).
          Fields are presented in alphabetical order.
          TEXT

          table_for solution_draft.changed_fields do
            column :field do |cf|
              SolutionDraft.human_attribute_name(cf.field)
            end

            column "Current Value" do |cf|
              cf.try_diffing_source self
            end

            column "Value to Apply" do |cf|
              cf.try_diffing_target self
            end
          end
        end if solution_draft.mutable?

        panel "History" do
          table_for(solution_draft.solution_draft_transitions.reorder(created_at: :desc, sort_key: :desc)) do
            column :state do |tr|
              status_tag tr.to_state
            end

            column :sort_key

            column :created_at do |tr|
              time_tag tr.created_at, title: tr.created_at.rfc2822 do
                concat time_ago_in_words(tr.created_at)
                concat " ago"
              end
            end
          end
        end if solution_draft.solution_draft_transitions.exists?
      end

      render "admin/solutions/shared_show_tabs", context: self
    end

    active_admin_comments_for(resource)
  end

  sidebar :request_review, only: :show, if: proc { authorized?(:request_review, resource) && solution_draft.can_transition_to?(:in_review) } do
    para <<~TEXT.html_safe
    Click the following link when you are ready for an administrator to review these changes.
    TEXT

    link_to "Request Review", request_review_admin_solution_solution_draft_path(solution_draft.solution, solution_draft), method: :put
  end

  sidebar :request_revision, only: :show, if: proc { authorized?(:request_revision, resource) && solution_draft.can_transition_to?(:pending) } do
    para <<~TEXT.html_safe
    If these changes need to be revised, click the following button to put the draft back in the <span class="status_tag pending">pending</span> state.
    TEXT

    link_to "Request Editor Revisions", request_revision_admin_solution_solution_draft_path(solution_draft.solution, solution_draft), method: :put
  end

  sidebar :approve, only: :show, if: proc { authorized?(:approve, resource) && solution_draft.can_transition_to?(:approved) } do
    para <<~TEXT.html_safe
    Click the following link if these changes should be approved and applied to the solution.
    TEXT

    link_to "Approve Changes", approve_admin_solution_solution_draft_path(solution_draft.solution, solution), method: :put
  end

  sidebar :reject, only: :show, if: proc { authorized?(:reject, resource) && solution_draft.can_transition_to?(:rejected) } do
    para <<~TEXT.html_safe
    Click the following link if this draft should be rejected entirely and locked from further editing,
    without deleting the history on this draft.
    TEXT

    para link_to "Reject Changes", reject_admin_solution_solution_draft_path(solution_draft.solution, solution), method: :put

    para <<~TEXT.html_safe
    <strong>Note:</strong> If there is no reason to keep the comment history or changes around, just delete the draft instead.
    TEXT
  end
end
