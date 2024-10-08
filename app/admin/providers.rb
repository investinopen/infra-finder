# frozen_string_literal: true

ActiveAdmin.register Provider do
  menu priority: 3

  permit_params :name, :url

  filter :name

  scope :all

  scope :with_multiple_solutions

  config.per_page = 100

  config.sort_order = "name_asc"

  index do
    selectable_column

    column :name
    column :solutions_count
    column :url, sortable: false
    column :updated_at

    actions do |provider|
      if current_user.has_any_admin_access?
        br
        item "Manage Access", admin_provider_provider_editor_assignments_path(provider)
      end
    end
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :url, as: :url
    end

    f.actions
  end

  show title: -> { _1.name.html_safe } do
    attributes_table do
      row :name
      row :solutions_count
      row :url

      row :created_at
      row :updated_at
    end

    panel "Solutions" do
      table_for resource.solutions do
        column :name do |s|
          link_to s.name, admin_solution_path(s)
        end

        column "Details" do |s|
          link_to "View on Website", solution_path(s)
        end
      end
    end

    active_admin_comments_for(resource)
  end

  action_item :manage_access, only: :show, if: proc { current_user.has_any_admin_access? } do
    link_to "Manage Access", admin_provider_provider_editor_assignments_path(provider)
  end
end
