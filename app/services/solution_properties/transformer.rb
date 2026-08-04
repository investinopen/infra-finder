# frozen_string_literal: true

module SolutionProperties
  # @abstract
  class Transformer < Dry::Transformer::Pipe
    import SolutionProperties::Functions
  end
end
