# frozen_string_literal: true

module VOG
  # A concern for defining and reloading columns that may be
  # managed by direct SQL execution, such as positioning and
  # other calculated attributes.
  #
  # @!attribute [r] managed_columns
  # @!scope class
  # A collection of columns that might be modified
  # by procedures outside standard Rails model lifecycle actions.
  # @return [Support::ClassyList::List<Symbol>]
  module ManagedColumns
    extend ActiveSupport::Concern

    include VOG::ColumnHandling
    include Support::ClassyList::DSL

    included do
      has_simple_symbol_list! :managed_columns
    end

    # @return [void]
    def reload_managed_columns!
      reload_columns!(*managed_columns)
    end
  end
end
