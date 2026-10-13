# frozen_string_literal: true

module Types
  # @see HasVisibility
  class VisibilityType < Types::BaseEnum
    description <<~TEXT
    Whether a record appears on the public site.
    TEXT

    value "VISIBLE", value: "visible" do
      description "Shown on the public site."
    end

    value "HIDDEN", value: "hidden" do
      description "Hidden from the public site."
    end
  end
end
