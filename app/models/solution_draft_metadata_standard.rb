# frozen_string_literal: true

class SolutionDraftMetadataStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_metadata
end
