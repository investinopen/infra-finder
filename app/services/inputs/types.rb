# frozen_string_literal: true

module Inputs
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    include Dry::Core::Constants

    BaseSchema = Hash.schema(EMPTY_HASH).with_key_transform(&:to_sym)

    CountryCode = Inputs::Types::Coercible::String.enum(
      *ISO3166::Country.pluck(:alpha2).flatten
    ).optional.fallback(nil)

    Currency = Inputs::Types::Coercible::String.default("USD").enum(
      *Money::Currency.all.map(&:iso_code)
    ).fallback("USD")

    DestroyFlag = Params::Bool.default(false).fallback(false)

    ENUMS = {
      financial_numbers_publishability: "unknown",
      implementation_status: "unknown",
      pricing_implementation_status: "unknown",
      publication: "unpublished",
    }.to_h do |name, default|
      [name, ApplicationRecord.dry_pg_enum(name, default:)]
    end.with_indifferent_access.merge(
      countries: CountryCode,
      currencies: Currency
    ).freeze

    # The key for {NestedAttributesList}. A stringified index.
    NestedKey = Coercible::String.constrained(format: /\A[0-9]+\z/)

    EMPTY_KEY = "__empty__"

    # This type represents a hash of nested attributes, where the keys are {NestedKey} and the values are of a specified type.
    # It is used to handle nested attributes in forms.
    NestedAttributesList = ->(value_type) do
      Hash.map(NestedKey, value_type).fallback(Dry::Core::Constants::EMPTY_HASH).constructor do |value|
        case value
        when Hash
          empty = value.fetch(EMPTY_KEY, Dry::Core::Constants::EMPTY_HASH)

          is_empty = ->(input) do
            if empty.present?
              empty.all? do |key, val|
                input[key] == val
              end
            else
              input.values.none? { _1.present? || _1 == false }
            end
          end

          value.without(EMPTY_KEY).each_with_object({}) do |(key, value), result|
            next unless NestedKey.valid?(key) && value_type.valid?(value)
            next if is_empty.(value)

            result[key.to_s] = value
          end
        when Array
          value.select do |item|
            value_type.valid?(item)
          end.each_with_index.with_object({}) do |(item, index), result|
            result[index.to_s] = item
          end
        else
          Dry::Core::Constants::EMPTY_HASH
        end
      end
    end

    # This coerces an input into a list of values, transparently handling nested attribute lists
    # and turning them into a flat array of hashes for processing.
    List = ->(value_type, nested_type: nil) do
      Array.of(value_type).constructor do |value|
        nested_type ||= Inputs::Types::NestedAttributesList[value_type]

        case value
        in Array => arr
          arr.filter_map { value_type.try(_1).to_monad.value_or(nil) }
        in nested_type => nested
          nested.values.filter_map { value_type.try(_1).to_monad.value_or(nil) }
        end
      end
    end

    module Attributes
      ZERO = BigDecimal(0)

      Bool = Inputs::Types::Params::Bool

      Date = Inputs::Types::Params::Date.optional.fallback(nil)

      Integer = Inputs::Types::Coercible::Integer.optional.fallback(nil)

      ID = Inputs::Types::String.constrained(filled: true).constructor do |value|
        case value
        when ::String then value.strip.presence
        when ::ActiveRecord::Base then value.id
        else
          raise Dry::Types::CoercionError, "invalid ID: #{value.inspect}"
        end
      end.optional.fallback(nil)

      IDs = Inputs::Types::Array.of(ID).constructor do |value|
        case value
        when ::Array
          value
        when ::String
          value.split(/\s*,\s*/).map(&:strip).compact_blank
        else
          Kernel.Array(value)
        end.flatten.map { |elm| ID[elm] }.compact_blank
      end.optional

      Money = Support::Types::BigDecimal.default(ZERO).fallback(ZERO)

      String = Inputs::Types::Coercible::String.optional.constructor do |value|
        value.to_s.strip.presence
      end
    end

    module Enums
      Countries = Inputs::Types::ENUMS.fetch(:countries)

      Currencies = Inputs::Types::ENUMS.fetch(:currencies)

      FinancialNumbersPublishability = Inputs::Types::ENUMS.fetch(:financial_numbers_publishability)

      ImplementationStatus = Inputs::Types::ENUMS.fetch(:implementation_status)

      PricingImplementationStatus = Inputs::Types::ENUMS.fetch(:pricing_implementation_status)

      Publication = Inputs::Types::ENUMS.fetch(:publication)
    end
  end
end
