# frozen_string_literal: true

ActiveAdmin.register User do
  menu parent: "System", priority: 0

  permit_params :email, :name, :super_admin, :admin, :kind, :password, :password_confirmation

  filter :email
  filter :kind
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  index do
    selectable_column

    column :email
    column :kind do |u|
      status_tag u.kind
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :super_admin
      f.input :admin

      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end

  show do
    attributes_table do
      row :email
      row :name

      row :kind

      row :current_sign_in_at
      row :current_sign_in_ip

      row :last_sign_in_at
      row :last_sign_in_ip

      row :created_at
      row :updated_at

      row :locked_at
    end

    active_admin_comments_for(resource)
  end
end
