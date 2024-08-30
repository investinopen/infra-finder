# frozen_string_literal: true

ActiveAdmin.register SolutionImport do
  menu parent: "System", priority: 1

  controller do
    def build_resource_params
      super.tap do |params|
        params[0].merge!(user_id: current_user.id)
      end
    end
  end

  permit_params :source, :strategy, options_attributes: %i[auto_approve]

  actions :all, except: %i[edit update]

  config.sort_order = "updated_at_desc"

  filter :strategy, as: :select, include_blank: true, collection: ApplicationRecord.pg_enum_select_options(:solution_import_strategy)
  filter :user, include_blank: true, collection: User.for_filter_collection

  scope :all

  scope :pending, group: :state
  scope :invalid, group: :state
  scope :started, group: :state
  scope :success, group: :state
  scope :failure, group: :state

  config.sort_order = "updated_at_desc"

  index title: "Imports" do
    selectable_column

    column :identifier
    column :user, sortable: false
    column :current_state, sortable: false do |r|
      status_tag r.current_state
    end
    column :strategy, sortable: false do |r|
      status_tag r.strategy
    end
    column :created_at
    column :updated_at

    actions
  end

  show do
    tabs do
      tab "Info" do
        attributes_table do
          row :user
          row :current_state do |r|
            status_tag r.current_state
          end
          row :strategy do |r|
            status_tag r.strategy
          end
          row :created_at
          row :updated_at
        end

        panel "Source" do
          attributes_table_for resource.source do
            row :original_filename
            row :content_type
            row :size do |r|
              number_to_human_size(r.size)
            end
          end
        end

        panel "Options" do
          attributes_table_for resource.options do
            row "Auto-approve?" do |r|
              r.auto_approve?
            end
          end
        end
      end

      tab "Log" do
        panel "Messages" do
          para <<~TEXT
          These messages are provided for developer debugging more than anything else,
          and are displayed in reverse chronological order. The last / final messages
          are at the top.
          TEXT

          table_for resource.messages do
            column :level do |r|
              status_tag r.level, class: r.level.to_s
            end

            column "Time" do |r|
              r.at
            end

            column :message

            column "Tags" do |r|
              filtered_tags = r.tags.without("persist_each_solution")

              next nil if filtered_tags.blank?

              # need to return nil here to avoid double-posting, ARB is weird.
              filtered_tags.map { status_tag _1 }.join(", ") && nil
            end
          end
        end
      end
    end

    active_admin_comments_for(resource)
  end

  form do |f|
    semantic_errors

    f.inputs do
      f.input :source, as: :file, required: true, input_html: { accept: "text/csv" }
      f.input :strategy, as: :select, collection: SolutionImport.strategy_select_options, required: true, include_blank: true
      f.inputs name: "Options", for: :options do |of|
        of.input :auto_approve, as: :boolean
      end
    end

    actions
  end
end
