# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::SCALARS
  class ScalarKindType < Types::BaseEnum
    description <<~TEXT
    The kind of a single value, for choosing an input.
    TEXT

    value "STRING", description: "A single line of text."
    value "TEXT", description: "Multiple lines of text."
    value "INTEGER", description: "A whole number."
    value "BOOLEAN", description: "True or false."
    value "DATE", description: "A calendar date."
    value "YEAR", description: "A year, stored as a date."
    value "DATETIME", description: "A date and time."
    value "URL", description: "An HTTP(S) URL."
    value "EMAIL", description: "An email address."
    value "CONTACT", description: "A URL or an email address."
    value "MONEY", description: "An amount of money; the currency is a separate property."
    value "IMAGE", description: "An uploaded image."
  end
end
