# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Boolean < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :boolean

      parse_with! Types::Params::Bool
    end
  end
end
