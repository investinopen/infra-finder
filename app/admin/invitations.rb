# frozen_string_literal: true

ActiveAdmin.register Invitation do
  menu parent: "System", priority: 1

  controller do
    def build_resource_params
      super.tap do |params|
        params[0].merge!(admin_id: current_user.id)
      end
    end
  end

  permit_params :provider_id, :email, :first_name, :last_name

  actions :all, except: %i[show edit update]

  config.sort_order = "updated_at_desc"

  filter :provider, include_blank: true, collection: Provider.for_filter_collection

  index do
    selectable_column

    column :provider, sortable: false
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    semantic_errors

    f.inputs do
      f.input :provider, collection: Provider.to_select_options, include_blank: true
      f.input :email, as: :email, input_html: { autocomplete: "off" }
      f.input :first_name, as: :string, input_html: { autocomplete: "off" }
      f.input :last_name, as: :string, input_html: { autocomplete: "off" }
    end

    actions
  end

  sidebar :help do
    para <<~TEXT
    Creating an invitation will automatically create a user, assign them to a provider,
    and send a notification welcoming them to start contributing in Infra Finder.
    TEXT
  end
end
