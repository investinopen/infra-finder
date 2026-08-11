# frozen_string_literal: true

module Support
  module Generators
    module FormattedNaming
      extend ActiveSupport::Concern

      include Support::Generators::Quoting

      private

      def formatted_namespace_name(&)
        formatted_namespace_for(namespace_name, &)
      end

      # @return [String]
      def base_class_name
        @base_class_name ||= derive_base_class_name
      end

      # @return [String]
      def derive_base_class_name = class_name.demodulize

      def derive_namespace_name = class_name.deconstantize

      # @return [String]
      def namespace_name
        @namespace_name ||= derive_namespace_name
      end
    end
  end
end
