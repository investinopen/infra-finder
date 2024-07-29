# frozen_string_literal: true

class CurrencyValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return unless value.present? && ::Money::Currency.find(value).blank?

    record.errors.add attribute, :unknown_currency
  end
end
