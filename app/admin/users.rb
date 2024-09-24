# frozen_string_literal: true

ActiveAdmin.register User do
  menu parent: "System", priority: 0

  permit_params :email, :name, :super_admin, :admin, :password, :password_confirmation,
    :comment_notifications, :reminder_notifications, :solution_notifications

  filter :email
  filter :name
  filter :kind
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  scope :all, default: true

  scope "Super Admins", :super_admin_kind, group: :kind
  scope "Admins", :admin_kind, group: :kind
  scope "Editors", :editor_kind, group: :kind
  scope "Unassigned", :unassigned_kind, group: :kind

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

    actions do |user|
      br
      item "Send Reset PW", send_reset_password_instructions_admin_user_path(user), method: :put
    end
  end

  form do |f|
    f.inputs do
      f.input :email, required: true, input_html: { autocomplete: "off" }
      f.input :name, as: :string, required: true, input_html: { autocomplete: "off" }
      f.input :super_admin, input_html: { autocomplete: "off" }
      f.input :admin, input_html: { autocomplete: "off" }

      if f.object.new_record?
        f.input :password, required: true, input_html: { autocomplete: "new-password" }
        f.input :password_confirmation, required: true, input_html: { autocomplete: "new-password" }
      end

      f.object.each_subscription_option do |option|
        f.input option.kind, as: :select, collection: ApplicationRecord.pg_enum_select_options(:subscription), include_blank: false
      end
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

      row :accepted_terms_at

      row :confirmed_at
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
    column :accepted_terms_at
    column :confirmed_at
    column :current_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_at
    column :last_sign_in_ip
    column :locked_at
    column :comment_notifications
    column :comment_notifications_updated_at
    column :solution_notifications
    column :solution_notifications_updated_at
    column :reminder_notifications
    column :reminder_notifications_updated_at
    column :created_at
    column :updated_at
  end

  sidebar :user_kinds, if: proc { current_user.has_any_admin_access? } do
    para "Users can exist as one of four kinds."

    dl do
      dt status_tag(:super_admin)
      dd "A super admin has full privileges within the admin section, is able to create and assign other admins, etc."
      dt status_tag(:admin)
      dd "A regular admin has access to managing solutions, controlled vocabularies, and inviting editors, but cannot manage user records directly."
      dt status_tag(:editor)
      dd "An editor can be assigned to providers, and create drafts for any solution owned by said provider(s)."
      dt status_tag(:unassigned)
      dd "Unassigned users have no privileges, and will be unable to access the admin section until they are assigned to a provider. This is the 'default' state for new users."
    end
  end

  action_item :send_reset_password_instructions, only: %i[show edit], if: proc { authorized?(:send_reset_password_instructions, resource) } do
    link_to "Send Password Reset Instructions", send_reset_password_instructions_admin_user_path(resource), method: :put
  end

  member_action :send_reset_password_instructions, method: :put do
    resource.send_reset_password_instructions

    redirect_to admin_user_path(resource), notice: t(".success", email: resource.email)
  end
end
