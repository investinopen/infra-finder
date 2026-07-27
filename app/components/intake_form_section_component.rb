# frozen_string_literal: true

# A titled section within the intake form
# @see IntakeFormComponent
class IntakeFormSectionComponent < ApplicationComponent
  # Each field is wrapped in a {FormFieldWrapperComponent}. Pass `class_name:` to
  # `with_field` to add layout classes to that wrapper, e.g.
  # `section.with_field(class_name: "wide") { ... }`.
  renders_many :fields, FormFieldWrapperComponent

  renders_many :text_blocks

  # @return [String]
  attr_reader :title

  # @return [String, nil]
  attr_reader :anchor

  # @return [String, nil]
  attr_reader :help_href

  # @param [String] title
  # @param [String, nil] anchor
  # @param [Boolean] help
  # @param [String, nil] help_href
  def initialize(title:, anchor: nil, help: true, help_href: nil)
    @title = title
    @anchor = anchor
    @help = help
    @help_href = help_href
  end

  # @return [Boolean]
  def help?
    @help
  end
end
