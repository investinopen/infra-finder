# frozen_string_literal: true

class ControlledVocabularyTermValidator < ActiveModel::EachValidator
  CONTAINS_SEPARATOR = /\|/

  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return unless CONTAINS_SEPARATOR.match?(value)

    record.errors.add attribute, :term_contains_semicolon
  end
end
