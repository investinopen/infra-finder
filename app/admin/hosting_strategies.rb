# frozen_string_literal: true

ActiveAdmin.register HostingStrategy do
  menu parent: "Options"

  permit_params :name, :description, :visibility

  filter :name
  filter :visibility

  index do
    selectable_column

    column :name
    column :visibility

    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :visibility, as: :select

      f.input :description, rows: 4
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :visibility

      row :description

      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end
end
