# frozen_string_literal: true

module SolutionIntakes
  class TransitionMetadata
    include Support::EnhancedStoreModel

    strip_attributes

    attribute :note, :string
  end
end
