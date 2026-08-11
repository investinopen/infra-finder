# frozen_string_literal: true

module Support
  module Generators
    module HasAttrMapping
      extend ActiveSupport::Concern

      private

      def attr_mapping
        @attr_mapping ||= Support::Generators::AttrMapping.new
      end

      def attr_mapping? = attr_mapping.present?

      def each_attr_mapping_entry(&)
        attr_mapping.each_quoted_entry(&)
      end
    end
  end
end
