# frozen_string_literal: true

module Types
  # @see Money
  class MoneyType < Types::BaseObject
    description <<~TEXT
    An amount of money in a specific currency.
    TEXT

    field :amount, String, null: false do
      description "The amount as a decimal string with the currency's decimal places, e.g. `\"1234.50\"` (or `\"100\"` for yen)."
    end

    field :cents, GraphQL::Types::BigInt, null: false do
      description "The amount in the currency's smallest unit."
    end

    field :currency, String, null: false do
      description "The ISO 4217 currency code."
    end

    field :formatted, String, null: false do
      description "The amount formatted for display, e.g. `$1,234.56`."
    end

    # @return [String]
    def amount = ActiveSupport::NumberHelper.number_to_rounded(object.amount, precision: object.currency.decimal_places)

    # @return [String]
    def currency = object.currency.iso_code

    # @return [String]
    def formatted = object.format
  end
end
