# frozen_string_literal: true

module Implementations
  class WebAccessibility < Implementations::AbstractImplementation
    with_link!
    with_statement!

    attribute :applies_to_solution, :boolean, default: false
    attribute :applies_to_website, :boolean, default: false

    def applies?
      applies_to_solution? || applies_to_website?
    end

    class << self
      def build_dry_schema
        super.tap do |schema|
          schema[:applies_to_solution] = Solutions::Types::Bool.default(false)
          schema[:applies_to_website] = Solutions::Types::Bool.default(false)
        end
      end
    end
  end
end
