# frozen_string_literal: true

ActiveAdmin.register License do
  menu parent: "Options"

  permit_params :name, :description, :url

  filter :name

  index do
    selectable_column

    column :name
    column :url

    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :url

      f.input :description, rows: 4
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :url

      row :description

      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end
end
