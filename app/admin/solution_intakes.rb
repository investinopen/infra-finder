# frozen_string_literal: true

ActiveAdmin.register SolutionIntake do
  menu priority: 2

  actions :all

  permit_params :name, :provider_id, :first_name, :last_name, :email

  filter :provider, include_blank: true

  config.sort_order = "updated_at_desc"

  scope :all

  scope :pending, group: :state
  scope :in_review, group: :state
  scope :approved, group: :state
  scope :rejected, group: :state

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
      item "User Form", edit_solution_intake_path(intake), target: "_blank"
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

    active_admin_comments_for resource
  end
end
