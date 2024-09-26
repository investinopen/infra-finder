# frozen_string_literal: true

ActiveAdmin.register SolutionDraft do
  belongs_to :solution

  actions :all, except: %i[new create]

  permit_params do
    SolutionDraft.build_strong_params(current_user:, draft: true)
  end

  controller do
    before_create :apply_editor_validations!

    before_update :apply_editor_validations!

    # @param [SolutionDraft] solution_draft
    # @return [void]
    def apply_editor_validations!(solution_draft)
      solution_draft.apply_editor_validations = true
    end

    def handle_simple_draft_operation!(operation_name)
      memo = params.dig(operation_name, :memo)

      user = current_user

      options = { memo:, user:, }

      resource.public_send(operation_name, **options) do |m|
        m.success do
          redirect_to(admin_solution_solution_draft_path(resource.solution, resource), notice: t(".success"))
        end

        m.failure do
          redirect_to(admin_solution_solution_drafts_path(resource.solution), alert: t("api.errors.something_went_wrong"))
        end
      end
    end
  end

  filter :user, include_blank: true

  config.sort_order = "updated_at_desc"

  scope :all

  scope :pending, group: :state
  scope :in_review, group: :state
  scope :approved, group: :state
  scope :rejected, group: :state

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
      tab "Draft Information" do
        attributes_table do
          row :current_state do |draft|
            status_tag draft.current_state
          end

          row :solution
          row :provider
          row "Editor" do |draft|
            draft.user
          end
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
          table_for(solution_draft.solution_draft_transitions.for_admin_history) do
            column :state do |tr|
              status_tag tr.to_state
            end

            column "When" do |tr|
              time_tag tr.created_at, title: tr.created_at.rfc2822 do
                concat time_ago_in_words(tr.created_at)
                concat " ago"
              end
            end

            column "Memo" do |tr|
              simple_format tr.memo
            end
          end
        end if solution_draft.solution_draft_transitions.exists?
      end

      InfraFinder::Container["solution_properties.admin.render"].(render_mode: :show, solution_kind: :draft, view_context: self)
    end

    active_admin_comments_for(resource)
  end

  WorkflowDefinition.each do |defn|
    member_action defn.action, method: :put do
      handle_simple_draft_operation!(defn.action)
    end

    sidebar defn.action, only: :show, if: proc { authorized?(defn.action, resource) && solution_draft.can_transition_to?(defn.to_state) } do
      para simple_format(defn.legend) if defn.legend?

      workflow = SolutionDrafts::Workflow.new

      active_admin_form_for(workflow, as: defn.action, url: url_for([defn.action, :admin, solution_draft.solution, solution_draft]), method: :put) do |f|
        f.inputs do
          f.input :memo, as: :text
        end

        f.actions do
          f.action :submit, label: defn.action
        end
      end
    end
  end
end
