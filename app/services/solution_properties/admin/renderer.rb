# frozen_string_literal: true

module SolutionProperties
  module Admin
    # @see SolutionProperties::Admin::Render
    class Renderer < Support::HookBased::Actor
      extend Dry::Core::Cache

      include Dry::Effects::Handler.Reader(:form)
      include Dry::Effects::Handler.Reader(:render_mode)
      include Dry::Effects::Handler.Reader(:solution_kind)
      include Dry::Effects::Handler.Reader(:view_context)
      include Dry::Effects::Handler.State(:form_access)

      include Dry::Initializer[undefined: false].define -> do
        option :form, Types::Any.optional, optional: true
        option :render_mode, SolutionProperties::Types::AdminRenderMode
        option :solution_kind, SolutionProperties::Types::SolutionKind, default: proc { :actual }
        option :view_context, Types::Any
      end

      standard_execution!

      # @return [<String>]
      attr_reader :expected_form_fields

      # @return [ActiveSupport::HashWithIndifferentAccess{ String => Integer }]
      attr_reader :form_access

      # @return [<SolutionProperties::Admin::TabWrapper>]
      attr_reader :wrapped_tabs

      def call
        run_callbacks :execute do
          yield prepare!

          yield render!
        end

        Success nil
      end

      wrapped_hook! def prepare
        @wrapped_tabs = yield InfraFinder::Container["solution_properties.admin.parse_tabs"].()

        @expected_form_fields = load_expected_form_fields

        @form_access = Hash.new { |h, k| h[k] = 0 }.with_indifferent_access

        super
      end

      wrapped_hook! def render
        wrapped_tabs.each do |tab|
          tab.render!
        end
      end

      around_render :provide_form!
      around_render :provide_render_mode!
      around_render :provide_solution_kind!
      around_render :provide_view_context!
      around_render :track_form_access!, if: :should_track_form_access?

      private

      # @return [<String>]
      def load_expected_form_fields
        fetch_or_store :expected_form_fields, render_mode, solution_kind do
          if rendering_form?
            SolutionProperty.admin_fields_for(solution_kind)
          else
            [].freeze
          end
        end
      end

      # @return [void]
      def provide_form!
        with_form form do
          yield
        end
      end

      # @return [void]
      def provide_render_mode!
        with_render_mode render_mode do
          yield
        end
      end

      # @return [void]
      def provide_solution_kind!
        with_solution_kind solution_kind do
          yield
        end
      end

      # @return [void]
      def provide_view_context!
        with_view_context view_context do
          yield
        end
      end

      def rendering_form?
        render_mode == :form
      end

      def should_track_form_access?
        rendering_form? && Rails.env.local?
      end

      # @return [void]
      def track_form_access!
        with_form_access form_access do
          yield
        end

        rendered = form_access.keys

        unaccounted = expected_form_fields - rendered

        # :nocov:
        raise "Did not render input for expected prop(s): #{unaccounted.inspect}" if unaccounted.any?
        # :nocov:
      end
    end
  end
end
