# frozen_string_literal: true

# @see IntakeFormComponent
class IntakeRadioGroupComponent < ApplicationComponent
  # @return [ActionView::Helpers::FormBuilder]
  attr_reader :form

  # @return [Symbol]
  attr_reader :attr

  # @return [<(String, Object)>]
  attr_reader :options

  # @return [String, nil]
  attr_reader :labelled_by

  # @param [ActionView::Helpers::FormBuilder] form
  # @param [Symbol] attr
  # @param [<(String, Object)>] options label/value pairs
  # @param [String, nil] labelled_by
  def initialize(form:, attr:, options:, labelled_by: nil)
    @form = form
    @attr = attr
    @options = options
    @labelled_by = labelled_by
  end
end
