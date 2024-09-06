# frozen_string_literal: true

ActiveAdmin.register SolutionRevision do
  belongs_to :solution

  actions :all, except: %i[new create edit update destroy]

  filter :user, include_blank: true

  config.sort_order = "created_at_desc"

  scope :all

  index do
    selectable_column

    column :user, sortable: false

    column :kind, sortable: false do |r|
      status_tag r.kind
    end

    column :provider_state, sortable: false do |r|
      status_tag r.provider_state
    end

    column :created_at, sortable: false

    actions
  end

  show do
    attributes_table do
      row :solution
      row :solution_draft
      row :provider

      row :provider_state do |r|
        status_tag(r.provider_state)
      end

      row :user

      row :kind do |r|
        status_tag r.kind
      end

      row :note

      row :reason

      row :created_at
    end

    panel "Property Changes" do
      table_for resource.diffs do
        column "Property" do |d|
          d.label
        end

        column "Action" do |d|
          status_tag d.sigil, class: d.status_color, title: d.status_title
        end

        column :old_value do |d|
          unless d.set?
            d.display_old_value
          else
            status_tag("n/a")
          end
        end

        column :new_value do |d|
          unless d.unset?
            d.display_new_value
          else
            status_tag("n/a")
          end
        end
      end
    end

    active_admin_comments_for(resource)
  end
end
