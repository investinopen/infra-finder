# frozen_string_literal: true

ActiveAdmin.register User do
  menu parent: "System", priority: 0

  permit_params :email, :name, :super_admin, :admin, :password, :password_confirmation

  filter :email
  filter :kind
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  scope :all, default: true

  scope "Super Admins", :super_admin_kind, group: :kind
  scope "Admins", :admin_kind, group: :kind
  scope "Editors", :editor_kind, group: :kind
  scope "Default (End Users)", :default_kind, group: :kind

  config.sort_order = "name_asc"

  index download_links: proc { current_user.super_admin? && %i[csv] } do
    selectable_column

    column :name
    column :email
    column :kind, sortable: false do |u|
      status_tag u.kind
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :updated_at

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

      row :kind do |u|
        status_tag u.kind
      end

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

  csv do
    column :id
    column :email
    column :name
    column :kind
    column :current_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_at
    column :last_sign_in_ip
    column :locked_at
    column :created_at
    column :updated_at
  end
end
