# frozen_string_literal: true

module ControlledVocabularies
  class Details
    include Support::EnhancedStoreModel

    attribute :enum_name, :string

    attribute :model_name, :string
  end
end
