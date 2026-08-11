# frozen_string_literal: true

module Support
  module Generators
    module HasExistingKlass
      extend ActiveSupport::Concern

      private

      # @return [Class<StoreModel::Model>]
      def klass
        @klass ||= class_name.constantize
      end
    end
  end
end
