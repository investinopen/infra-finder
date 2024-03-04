# frozen_string_literal: true

module Solutions
  module Implementations
    class WebAccessibility < Solutions::AbstractImplementation
      with_link!
      with_statement!

      attribute :applies_to_project, :boolean, default: false
      attribute :applies_to_website, :boolean, default: false

      def applies?
        applies_to_project? || applies_to_website?
      end
    end
  end
end
