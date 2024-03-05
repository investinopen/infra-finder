# frozen_string_literal: true

ActiveAdmin.register HostingStrategy do
  menu parent: "Options"

  permit_params :name, :description, :visibility

  filter :name
  filter :visibility, as: :select, collection: proc { ApplicationRecord.pg_enum_select_options(:visibility) }

  config.sort_order = "name_asc"

  index do
    selectable_column

    column :name
    column :visibility, sortable: false do |record|
      status_tag record.visibility
    end

    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :visibility, as: :select

      f.input :description, as: :text
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :visibility do |record|
        status_tag record.visibility
      end

      row :description

      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end
end
