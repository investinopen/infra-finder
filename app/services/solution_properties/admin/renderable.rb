# frozen_string_literal: true

module SolutionProperties
  module Admin
    module Renderable
      extend ActiveSupport::Concern

      include Dry::Effects.Reader(:form)
      include Dry::Effects.Reader(:render_mode)
      include Dry::Effects.Reader(:solution_kind)
      include Dry::Effects.Reader(:view_context)

      # @abstract
      # @return [void]
      def render
        case render_mode
        in :form
          render_for_form!
        else
          render_for_show!
        end
      end

      # @abstract
      # @return [void]
      def render!
        return if skip_render?

        render

        return nil
      end

      def actual?
        solution_kind == :actual
      end

      def draft?
        solution_kind == :draft
      end

      def form?
        render_mode == :form
      end

      def show?
        render_mode == :show
      end

      def skip_render?
        false
      end

      private

      # @abstract
      # @return [void]
      def render_for_form!; end

      # @abstract
      # @return [void]
      def render_for_show; end
    end
  end
end
