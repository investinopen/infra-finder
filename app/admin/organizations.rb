# frozen_string_literal: true

ActiveAdmin.register Organization do
  menu priority: 3

  permit_params :name, :url

  index do
    selectable_column

    column :name
    column :url
    column :created_at

    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :url, as: :url
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :url

      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end
end
