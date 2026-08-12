# frozen_string_literal: true

module SolutionIntakes
  class Workflow < Utility::FormObject
    attribute? :note, Types::Coercible::String.optional
  end
end
