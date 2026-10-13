# frozen_string_literal: true

module VOG
  module ColumnHandling
    extend ActiveSupport::Concern

    # @param [<Symbol>] column_names
    # @return [void]
    def reload_columns!(*column_names)
      column_names.flatten!
      column_names.compact_blank!

      return self if column_names.empty? || destroyed? || @attributes.frozen?

      projections = column_names.map { |c| self.class.arel_table[c] }

      # Fetch only the specified columns from the DB for this record
      # Ensure it's an array in case there's only one column,
      # since pick will flatten it
      fresh = self.class.where(self.class.primary_key => id).pick(*projections).then { Array(_1) }

      column_names.zip(fresh).each do |col_name, value|
        # write_from_database: sets the attribute as if loaded from DB
        # - no dirty tracking
        # - no callbacks
        # - respects the column's type casting
        @attributes.write_from_database(col_name.to_s, value)
      end

      self
    end
  end
end
