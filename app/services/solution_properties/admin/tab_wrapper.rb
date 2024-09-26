# frozen_string_literal: true

module SolutionProperties
  module Admin
    class TabWrapper
      include Renderable
      include Support::Typing
      include Dry::Core::Equalizer.new(:name)
      include Dry::Initializer[undefined: false].define -> do
        param :name, Types::String.constrained(filled: true)

        param :properties, SolutionProperties::Admin::PropertyWrapper::List.constrained(min_size: 1)
      end

      # @api private
      # @return [<SolutionProperties::Admin::FormInputs>]
      def form_inputs
        @form_inputs ||= group_for_form
      end

      # @return [void]
      def render
        view_context.tab name do
          super
        end
      end

      private

      # @return [void]
      def render_for_form!
        form_inputs.each(&:render!)
      end

      # @return [void]
      def render_for_show!
        view_context.attributes_table do
          properties.each(&:render!)
        end
      end

      def group_for_form
        groupings = properties.reject(&:always_skip_form?).chunk_while { |l, r| l.form_grouping_key == r.form_grouping_key }

        groupings.map do |properties|
          header = properties.first

          key = header.form_grouping_key

          options = header.form_grouping_options

          SolutionProperties::Admin::FormInputs.new(key, properties, **options)
        end
      end
    end
  end
end
