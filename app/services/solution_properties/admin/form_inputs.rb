# frozen_string_literal: true

module SolutionProperties
  module Admin
    class FormInputs
      include Renderable
      include Support::Typing
      include Dry::Core::Equalizer.new(:key)
      include Dry::Initializer[undefined: false].define -> do
        param :key, Types::String.constrained(filled: true)

        param :properties, SolutionProperties::Admin::PropertyWrapper::List.constrained(min_size: 1)

        option :label, Types::String, optional: true

        option :kind, Types::Symbol
      end

      # @return [void]
      def render_for_form!
        case kind
        in :implementation
          render_implementation!
        in :store_model_list
          render_store_model_list!
        else
          form.inputs label do
            properties.each(&:render!)
          end
        end
      end

      private

      # @return [void]
      def render_implementation!
        form.inputs label do
          properties.each(&:render!)
        end
      end

      # @return [void]
      def render_store_model_list!
        wrapper = properties.sole

        wrapper.render!
      end
    end
  end
end
