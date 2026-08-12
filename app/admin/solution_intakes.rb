# frozen_string_literal: true

ActiveAdmin.register SolutionIntake do
  menu priority: 2

  actions :all

  permit_params :name, :provider_id, :first_name, :last_name, :email

  controller do
    def handle_workflow_operation!(operation_name)
      note = params.dig(operation_name, :note)

      options = { current_user:, note:, source: "admin", }

      resource.public_send(operation_name, **options) do |m|
        m.success do
          redirect_to(admin_solution_intake_path(resource), notice: t(".success"))
        end

        m.failure do
          redirect_to(admin_solution_intakes_path, alert: t("api.errors.something_went_wrong"))
        end
      end
    end
  end

  filter :provider, include_blank: true

  config.sort_order = "updated_at_desc"

  scope :all

  scope :pending, group: :state
  scope :in_review, group: :state
  scope :approved, group: :state
  scope :rejected, group: :state

  scope :missing_provider

  index do
    selectable_column

    column :name
    column :provider
    column :current_state do |r|
      status_tag r.current_state
    end
    column :created_at
    column :updated_at

    actions do |intake|
      item "User Form", edit_solution_intake_path(intake), target: "_blank", rel: "noopener"
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :provider
      f.input :first_name, as: :string
      f.input :last_name, as: :string
      f.input :email, as: :email
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :provider
      row :current_state do |intake|
        status_tag intake.current_state
      end

      row :first_name
      row :last_name
      row :email

      row :created_at
      row :updated_at
    end

    panel "History" do
      table_for(solution_intake.solution_intake_transitions.for_admin_history) do
        column :state do |tr|
          status_tag tr.to_state
        end

        column :user

        column "Via" do |tr|
          status_tag tr.metadata.source
        end

        column "When" do |tr|
          time_tag tr.created_at, title: tr.created_at.rfc2822 do
            concat time_ago_in_words(tr.created_at)
            concat " ago"
          end
        end

        column "Note" do |tr|
          simple_format tr.note
        end
      end
    end if solution_intake.solution_intake_transitions.exists?

    active_admin_comments_for resource
  end

  action_item :view_user_form, only: %i[show edit], if: proc { solution_intake.mutable? } do
    link_to "View User Form", edit_solution_intake_path(solution_intake), target: "_blank", rel: "noopener"
  end

  action_item :view_solution, only: %i[show edit], if: proc { solution_intake.solution.present? } do
    link_to "View Solution", admin_solution_path(solution_intake.solution), target: "_blank", rel: "noopener"
  end

  sidebar "Important!" do
    para "If an intake is missing a provider, one must be set before it can be approved. User data can still be collected."
  end

  IntakeWorkflow.each do |defn|
    member_action defn.action, method: :put do
      handle_workflow_operation!(defn.action)
    end

    sidebar defn.action, only: :show, if: proc { authorized?(defn.action, resource) && solution_intake.can_transition_to?(defn.to_state) } do
      para simple_format(defn.legend) if defn.legend?

      workflow = SolutionIntakes::Workflow.new

      active_admin_form_for(workflow, as: defn.action, url: url_for([defn.action, :admin, solution_intake]), method: :put) do |f|
        f.inputs do
          f.input :note, as: :text
        end

        f.actions do
          f.action :submit, label: defn.label
        end
      end
    end
  end

  sidebar "Solution", only: :show, if: proc { solution_intake.solution.present? } do
    attributes_table_for solution_intake.solution do
      row :name do |solution|
        link_to solution.name, admin_solution_path(solution)
      end

      row :provider
      row :created_at
      row :updated_at
    end
  end

  sidebar "Help", only: %i[index] do
    para "This page shows all solution intakes submitted by users. You can view the details of each intake, including its current state and history of state transitions."

    para "To reset, approve, or reject an intake, click on the 'View' link for the intake and follow the actions in the sidebar."
  end
end
