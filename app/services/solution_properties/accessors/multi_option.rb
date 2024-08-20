# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class MultiOption < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :multi_option

      def process_default_csv_value(input)
        terms = split_controlled_vocabulary_terms input

        terms.map { vocab.find_term(_1).value_or(nil) }.compact
      end

      def to_csv
        case vocab.strategy
        in "model"
          join_controlled_vocabulary_terms super.pluck(:term)
        else
          # :nocov:
          join_controlled_vocabulary_terms super
          # :nocov:
        end
      end
    end
  end
end
