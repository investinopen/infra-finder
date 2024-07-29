# frozen_string_literal: true

class MetadataStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_metadata
end
