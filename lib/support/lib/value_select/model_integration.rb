# frozen_string_literal: true

module Support
  module ValueSelect
    # @note Intended to be `extend`ed on an ActiveRecord model class.
    module ModelIntegration
      # @param [<Support::ValueSelect::Types::Value>] rows
      # @param [Hash] options configuration to initialize the query
      # @return [Support::ValueSelect::Query]
      def value_select_query(rows, **options)
        options[:model_class] = self

        ::Support::ValueSelect::Query.new(rows, **options)
      end

      # @see #value_select_query
      # @return [String]
      def value_select_query_sql(...) = value_select_query(...).to_sql
    end
  end
end
