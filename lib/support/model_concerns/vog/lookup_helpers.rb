# frozen_string_literal: true

module VOG
  module LookupHelpers
    extend ActiveSupport::Concern

    include VOG::Filterable

    module ClassMethods
      def define_simple_lookup!(column_name, scope_name: :"lookup_by_#{column_name}")
        scope scope_name, ->(input) { where(column_name => input) }
      end

      def define_simple_lookups!(*columns)
        columns.each do |column_name|
          define_simple_lookup! column_name
        end
      end
    end
  end
end
