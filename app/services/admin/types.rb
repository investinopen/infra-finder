# frozen_string_literal: true

module Admin
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    CSVBuilder = Types.Instance(::ActiveAdmin::CSVBuilder)

    CSVScope = Symbol.default(:private).enum(:public, :private)

    CSVScopeSkips = Hash.map(CSVScope, Array.of(Symbol)).default { CSVScope.values.index_with { [].freeze }.freeze }
  end
end
