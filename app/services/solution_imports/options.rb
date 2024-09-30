# frozen_string_literal: true

module SolutionImports
  class Options
    include Support::EnhancedStoreModel

    attribute :auto_approve, :boolean, default: false
  end
end
