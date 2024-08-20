# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Enum < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :enum
    end
  end
end
