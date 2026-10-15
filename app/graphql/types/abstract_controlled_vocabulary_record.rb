# frozen_string_literal: true

module Types
  # @abstract The base class for the generated controlled vocabulary record types.
  #
  # @see Types::ControlledVocabularyRecordType
  class AbstractControlledVocabularyRecord < Types::AbstractModel
    implements ::Types::ControlledVocabularyRecordType
  end
end
