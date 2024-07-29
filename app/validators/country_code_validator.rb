# frozen_string_literal: true

class CountryCodeValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    return unless value.present? && ISO3166::Country[value].blank?

    record.errors.add attribute, :unknown_country_code
  end
end
