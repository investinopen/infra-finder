# frozen_string_literal: true

# @see IntakeFormComponent
# Typeahead multiselect field. Progressively enhances a native
# `<select multiple>` with Tom Select.
class TypeaheadComponent < ApplicationComponent
  # @return [ActionView::Helpers::FormBuilder]
  attr_reader :form

  # @return [Symbol]
  attr_reader :attr

  # @return [String, nil]
  attr_reader :labelled_by

  # @return [Integer, nil]
  attr_reader :max_items

  # @return [String, nil]
  attr_reader :placeholder

  # @return [String, nil]
  attr_reader :max_items_placeholder

  # @param [ActionView::Helpers::FormBuilder] form
  # @param [Symbol] attr
  # @param [String] vocab_name
  # @param [String, nil] labelled_by
  # @param [Integer, nil] max_items
  # @param [String, nil] placeholder
  # @param [String, nil] max_items_placeholder shown once `max_items` is reached
  def initialize(form:, attr:, vocab_name:, labelled_by: nil, max_items: nil, placeholder: nil,
                 max_items_placeholder: nil)
    @form = form
    @attr = attr
    @vocab_name = vocab_name
    @labelled_by = labelled_by
    @max_items = max_items
    @placeholder = placeholder || "Type to search..."
    @max_items_placeholder = max_items_placeholder
  end

  # @return [<(String, String, Hash)>]
  def options
    ControlledVocabulary.find(@vocab_name).fetch_options!
  end
end
