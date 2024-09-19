# frozen_string_literal: true

module SolutionProperties
  # Define and expose currency / finance values for {SolutionInterface}.
  #
  # @see SolutionProperty.currency_values
  module HasFinance
    extend ActiveSupport::Concern

    include BooleanEnums

    included do
      SolutionProperty.currency_values.each do |attr|
        monetize :"#{attr}_cents", with_model_currency: :currency
      end

      pg_enum! :financial_information_scope, as: :financial_information_scope, prefix: :financial_information_scope, allow_blank: false, default: "unknown"
      # pg_enum! :financial_numbers_applicability, as: :financial_numbers_applicability, prefix: :financial_numbers, default: "unknown"
      pg_enum! :financial_numbers_publishability, as: :financial_numbers_publishability, prefix: :financial_numbers, suffix: :to_publish, default: "unknown"

      boolean_enum! :financial_numbers_publishability, truthy: "approved", falsey: "unapproved", null: "unknown"

      validates :financial_information_scope, :financial_numbers_publishability, presence: true

      validates :financial_numbers_documented_url, url: { allow_blank: true }
    end
  end
end
