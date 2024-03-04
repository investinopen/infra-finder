# frozen_string_literal: true

module SolutionDrafts
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    include Solutions::Types
  end
end
