# frozen_string_literal: true

module ControlledVocabularies
  module Admin
    module Resource
      class << self
        def extended(base)
          base.add_controller_features!

          base.define_permitted_params!

          base.define_filters!

          base.define_index!

          base.define_show!

          base.define_form!

          base.add_replace_with_actions!

          base.config.sort_order = "name_asc"

          base.menu parent: "Controlled Vocabularies"
        end
      end

      def define_filters!
        filter :name

        filter :visibility, as: :select, collection: proc { ApplicationRecord.pg_enum_select_options(:visibility) }

        scope :all

        scope :used

        scope :unused
      end

      def define_form!
        form do |f|
          f.inputs do
            f.input :name

            f.input :bespoke_filter_position

            f.input :visibility, as: :select

            f.input :description, as: :text
          end

          f.actions
        end
      end

      def define_index!
        index do
          selectable_column

          column :name

          column :visibility, sortable: false do |record|
            status_tag record.visibility
          end

          column :solutions_count

          column :solution_drafts_count

          actions do |option|
            link_to "Replace", [:replace, :admin, option]
          end
        end
      end

      def define_permitted_params!
        params = %i[name bespoke_filter_position description term visibility]

        permit_params(*params)
      end

      def define_show!
        show do
          attributes_table do
            row :name

            row :bespoke_filter_position

            row :visibility do |record|
              status_tag record.visibility
            end

            row :description

            row :solutions_count

            row :solution_drafts_count

            row :created_at
            row :updated_at
          end

          panel "Solutions" do
            table_for resource.solutions.lazily_order(:name) do
              column :name do |r|
                link_to r.name, admin_solution_path(r)
              end
            end
          end

          active_admin_comments_for(resource)
        end
      end

      def add_controller_features!
        controller do
          include ControlledVocabularies::Admin::ControllerMethods
        end
      end

      # @return [void]
      def add_replace_with_actions!
        member_action :replace, method: :get do
          load_option_replacement!

          render "admin/controlled_vocabularies/replace"
        end

        member_action :replace_option, method: :put do
          load_option_replacement!

          option_replacement.update_from_form!(option_replacement_params)

          resource.replace_with(option_replacement.new_option) do |m|
            m.success do
              old_name = resource.name
              new_name = option_replacement.new_option.name

              redirect_to [:admin, resource_class], notice: t("admin.controlled_vocabularies.replaced", old_name:, new_name:, raise: true)
            end

            m.failure(:invalid) do |_, replacement|
              # :nocov:
              @option_replacement = replacement

              replacement_failed!
              # :nocov:
            end

            m.failure do
              # :nocov:
              replacement_failed!
              # :nocov:
            end
          end
        rescue ActiveRecord::RecordNotFound
          # :nocov:
          option_replacement.valid?

          replacement_failed!
          # :nocov:
        end

        action_item :replace, only: %i[show edit] do
          link_to "Replace", [:replace, :admin, resource]
        end
      end

      def resource_class
        config.resource_class
      end
    end
  end
end
