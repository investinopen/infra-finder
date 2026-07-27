# frozen_string_literal: true

class FormFieldWrapperComponent < ApplicationComponent
  renders_one :label

  renders_many :conditional_fields, ->(**options) { FormFieldWrapperComponent.new(**options, conditional: true) }

  # @return [String, nil]
  attr_reader :class_name

  # @return [String, nil]
  attr_reader :description

  # @return [{ field: Symbol, value: String, <String> }, nil]
  attr_reader :condition

  # @param [String, nil] class_name
  # @param [Boolean] required
  # @param [String, nil] description
  # @param [{ field: Symbol, value: String, <String> }, nil] condition only show this
  #   field when the form input named `field` has the, or a, value `value`
  def initialize(class_name: nil, required: false, description: nil, condition: nil, conditional: false)
    @class_name = class_name
    @required = required
    @description = description
    @condition = condition
    @conditional = conditional
  end

  # @return [Boolean]
  def conditional?
    @conditional
  end

  # @return [Symbol, nil]
  def condition_field
    condition&.fetch(:field)
  end

  # @return [String, nil]
  def condition_value
    return if condition.blank?

    Array(condition.fetch(:value)).join(" ")
  end

  # @return [Boolean]
  def required?
    @required
  end
end
