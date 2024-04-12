# frozen_string_literal: true

module SolutionOptionResource
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

      base.menu parent: "Options"
    end
  end

  def define_filters!
    filter :name

    if has_visibility?
      filter :visibility, as: :select, collection: proc { ApplicationRecord.pg_enum_select_options(:visibility) }
    end

    scope :all

    scope :used

    scope :unused
  end

  def define_form!
    form do |f|
      f.inputs do
        f.input :name

        if has_visibility?
          f.input :visibility, as: :select
        end

        f.input :description, as: :text
      end

      f.actions
    end
  end

  def define_index!
    index do
      selectable_column

      column :name

      if has_visibility?
        column :visibility, sortable: false do |record|
          status_tag record.visibility
        end
      end

      column :solutions_count

      column :solution_drafts_count

      actions do |option|
        link_to "Replace", [:replace, :admin, option]
      end
    end
  end

  def define_permitted_params!
    params = %i[name description]

    params << :visibility if has_visibility?

    permit_params(*params)
  end

  def define_show!
    show do
      attributes_table do
        row :name

        if has_visibility?
          row :visibility do |record|
            status_tag record.visibility
          end
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
    # rubocop:disable Lint/NestedMethodDefinition
    has_vis = has_visibility?

    controller do
      @has_visibility = has_vis

      delegate :has_visibility?, to: :class

      # @return [<SolutionOption>]
      attr_reader :available_replacement_options

      # @return [Solutions::OptionReplacement]
      attr_reader :option_replacement

      helper_method :available_replacement_options

      helper_method :has_visibility?

      helper_method :option_replacement

      def load_option_replacement!
        @option_replacement = Solutions::OptionReplacement.new(old_option: resource)

        @available_replacement_options = resource.class.where.not(id: resource.id).to_select_options
      end

      def option_replacement_params
        params.require(:option_replacement).permit(:new_option)
      end

      # @return [void]
      def replacement_failed!
        flash.now[:alert] = t("admin.solution_options.something_went_wrong")

        render "admin/solution_options/replace"
      end

      class << self
        def has_visibility?
          @has_visibility
        end
      end
    end
    # rubocop:enable Lint/NestedMethodDefinition
  end

  # @return [void]
  def add_replace_with_actions!
    member_action :replace, method: :get do
      load_option_replacement!

      render "admin/solution_options/replace"
    end

    member_action :replace_option, method: :put do
      load_option_replacement!

      option_replacement.update_from_form!(option_replacement_params)

      resource.replace_with(option_replacement.new_option) do |m|
        m.success do
          old_name = resource.name
          new_name = option_replacement.new_option.name

          redirect_to [:admin, resource_class], notice: t("admin.solution_options.replaced", old_name:, new_name:, raise: true)
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

  def has_visibility?
    resource_class < HasVisibility
  end

  def resource_class
    config.resource_class
  end
end
