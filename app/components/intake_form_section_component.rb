# frozen_string_literal: true

# A titled section within the intake form
# @see IntakeFormComponent
class IntakeFormSectionComponent < ApplicationComponent
  # Each field is wrapped in a {FormFieldWrapperComponent}. Pass `class_name:` to
  # `with_field` to add layout classes to that wrapper, e.g.
  # `section.with_field(class_name: "wide") { ... }`.
  renders_many :fields, FormFieldWrapperComponent

  # @return [String]
  attr_reader :title

  # @return [String, nil]
  attr_reader :anchor

  # @param [String] title
  # @param [String, nil] anchor
  def initialize(title:, anchor: nil)
    @title = title
    @anchor = anchor
  end
end
