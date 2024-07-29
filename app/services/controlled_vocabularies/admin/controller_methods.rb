# frozen_string_literal: true

module ControlledVocabularies
  module Admin
    module ControllerMethods
      extend ActiveSupport::Concern

      included do
        helper_method :available_replacement_options

        helper_method :option_replacement
      end

      # @return [<ControlledVocabularyRecord>]
      attr_reader :available_replacement_options

      # @return [ControlledVocabularies::Replacement]
      attr_reader :option_replacement

      def load_option_replacement!
        @option_replacement = ControlledVocabularies::Replacement.new(old_option: resource)

        @available_replacement_options = resource.class.where.not(id: resource.id).to_select_options
      end

      def option_replacement_params
        params.require(:option_replacement).permit(:new_option)
      end

      # @return [void]
      def replacement_failed!
        flash.now[:alert] = t("admin.controlled_vocabularies.something_went_wrong")

        render "admin/controlled_vocabularies/replace"
      end
    end
  end
end
