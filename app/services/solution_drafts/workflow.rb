# frozen_string_literal: true

module SolutionDrafts
  class Workflow < Utility::FormObject
    attribute? :memo, Types::Coercible::String.optional
  end
end
