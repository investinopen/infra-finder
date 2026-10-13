# frozen_string_literal: true

module VOGTesting
  module GQL
    class AttributeErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        AttributeErrorBuilder.build(...)
      end
    end
  end
end
