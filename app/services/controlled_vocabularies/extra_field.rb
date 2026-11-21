# frozen_string_literal: true

module ControlledVocabularies
  class ExtraField
    include Support::EnhancedStoreModel

    actual_enum :type, :boolean, :integer, :string, allow_blank: false

    attribute :name, :string
    attribute :label, :string
    attribute :required, :boolean, default: false

    before_validation :derive_label!

    validates :name, :type, presence: true

    # @return [Hash]
    def to_graphql = { name: name.camelize(:lower), label:, type:, required: }

    private

    # @return [void]
    def derive_label!
      self.label = parent&.model_klass&.human_attribute_name(name) || name.to_s.humanize
    end
  end
end
