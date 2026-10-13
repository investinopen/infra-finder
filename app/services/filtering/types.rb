# frozen_string_literal: true

module Filtering
  # Types used by the filtering subsystem.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    # A type representing the name of a filtering scope, which corresponds to a method on the model's ActiveRecord::Relation.
    ScopeName = Symbol

    # A list of {ScopeName}s.
    ScopeNames = Array.of(ScopeName)

    # A type representing a filtering scope.
    Filters = Instance(Filtering::FilterScope)

    # A type representing a class of filtering scopes.
    FiltersClass = Inherits(Filtering::FilterScope)

    # A type representing the input hash for filtering arguments.
    Input = Hash.fallback { {}.freeze }

    # A type representing an ActiveRecord scope / relation.
    Scope = Instance(ActiveRecord::Relation)
  end
end
