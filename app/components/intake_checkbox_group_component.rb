# frozen_string_literal: true

# @see IntakeFormComponent
class IntakeCheckboxGroupComponent < ApplicationComponent
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
  def initialize(form:, attr:, vocab_name:, labelled_by: nil)
    @form = form
    @attr = attr
    @vocab_name = vocab_name
    @labelled_by = labelled_by
  end

  # @return [<(String, String, Hash)>]
  def options
    ControlledVocabulary.find(@vocab_name).fetch_options!
  end
end
