# frozen_string_literal: true

module SolutionIntakes
  class TransitionMetadata
    include Support::EnhancedStoreModel

    strip_attributes

    actual_enum :source, :admin, :form, :unspecified, default: :unspecified, _prefix: :via

    attribute :note, :string
  end
end
