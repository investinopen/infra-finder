# frozen_string_literal: true

module VOG
  module VirtualColumnHandling
    extend ActiveSupport::Concern

    include VOG::ColumnHandling

    # Fetches current DB values for all virtual/generated columns
    # and writes them back into the in-memory attribute set,
    # **without** triggering reload, after_find, or after_initialize.
    def reload_virtual_columns!
      virtual_cols = self.class.columns.select(&:virtual?).map(&:name)

      reload_columns!(*virtual_cols)
    end

    # @param [{ Symbol => Object }] args
    def update_and_reload_columns(**args)
      update_columns(**args)
    ensure
      reload_virtual_columns!
    end
  end
end
