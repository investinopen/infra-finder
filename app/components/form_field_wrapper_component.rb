# frozen_string_literal: true

class FormFieldWrapperComponent < ApplicationComponent
  # @return [String, nil]
  attr_reader :class_name

  # @return [String, nil]
  attr_reader :description

  # @param [String, nil] class_name
  # @param [Boolean] required
  # @param [String, nil] description
  def initialize(class_name: nil, required: false, description: nil)
    @class_name = class_name
    @required = required
    @description = description
  end

  # @return [Boolean]
  def required?
    @required
  end
end
