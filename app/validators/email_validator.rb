# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations] record
  # @param [Symbol] attribute
  # @param [String] value
  # @return [void]
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add attribute, :invalid_email

      return
    end

    value = value.to_s.strip

    parsed = Mail::Address.new(value)
  rescue Mail::Field::ParseError
    record.errors.add attribute, :invalid_email
  else
    if parsed.address != value
      record.errors.add attribute, :invalid_email_structure
    elsif parsed.domain.blank?
      record.errors.add attribute, :invalid_email_domain
    end
  end

  # @api private
  # @note Used in tests.
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Validations

    # @return [Array]
    attr_accessor :email

    validates :email, email: true
  end
end
