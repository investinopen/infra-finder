# frozen_string_literal: true

module ControlledVocabularies
  module HasStrategy
    extend ActiveSupport::Concern

    included do
      add_index :strategy

      scope :by_strategy, ->(strategy) { where(strategy:) }

      scope :uses_countries, -> { by_strategy("countries") }
      scope :uses_currencies, -> { by_strategy("currencies") }
      scope :uses_enum, -> { by_strategy("enum") }
      scope :uses_model, -> { by_strategy("model") }
    end

    def uses_enum?
      uses?("enum")
    end

    def uses_model?
      uses?("model")
    end

    # @param [ControlledVocabularies::Types::Strategy]
    def uses?(strategy)
      self.strategy == strategy
    end
  end
end
