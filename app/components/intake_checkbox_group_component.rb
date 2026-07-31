# frozen_string_literal: true

# @see IntakeFormComponent
class IntakeCheckboxGroupComponent < ApplicationComponent
  CONTROLLER = "intake-checkbox-group-component--intake-checkbox-group-component"

  # @return [ActionView::Helpers::FormBuilder]
  attr_reader :form

  # @return [Symbol]
  attr_reader :attr

  # @return [String, nil]
  attr_reader :labelled_by

  # @param [ActionView::Helpers::FormBuilder] form
  # @param [Symbol] attr
  # @param [String] vocab_name
  # @param [String, nil] labelled_by
  # @param [Boolean] required whether at least one option must be checked
  def initialize(form:, attr:, vocab_name:, labelled_by: nil, required: false)
    @form = form
    @attr = attr
    @vocab_name = vocab_name
    @labelled_by = labelled_by
    @required = required
  end

  # @return [Boolean]
  def required?
    @required
  end

  # @return [Hash]
  def group_data
    required? ? { controller: CONTROLLER } : {}
  end

  # @return [<(String, String, Hash)>]
  def options
    ControlledVocabulary.find(@vocab_name).fetch_options!
  end
end
