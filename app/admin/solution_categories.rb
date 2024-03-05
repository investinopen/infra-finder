# frozen_string_literal: true

ActiveAdmin.register SolutionCategory do
  menu parent: "Options"

  permit_params :name, :description

  filter :name

  config.sort_order = "name_asc"

  index do
    selectable_column

    column :name

    actions
  end

  form do |f|
    f.inputs do
      f.input :name

      f.input :description, as: :text
    end

    f.actions
  end

  show do
    attributes_table do
      row :name

      row :description

      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end
end
