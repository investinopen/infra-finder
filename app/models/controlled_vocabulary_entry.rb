# frozen_string_literal: true

# @see ControlledVocabulary
class ControlledVocabularyEntry < ApplicationRecord
  include TimestampScopes

  pg_enum! :strategy, as: :controlled_vocabulary_strategy, allow_blank: false, prefix: :as

  attribute :details, ControlledVocabularies::Details.to_type
  attribute :extra_fields, ControlledVocabularies::ExtraField.to_array_type

  before_validation :calculate_values!

  validates :name, :kind, presence: true, uniqueness: true
  validates :label, presence: true
  validates :details, :extra_fields, store_model: true

  # @!attribute [r] model_klass
  # @return [Class(ApplicationRecord), nil]
  delegate :model_klass, to: :actual

  def actual
    @actual ||= load_actual
  end

  private

  # @return [Integer]
  def derive_records_count = actual.calculate_records_count

  def load_actual = ControlledVocabulary.find(name)

  # @return [void]
  def calculate_values!
    self.records_count = derive_records_count
  end
end
