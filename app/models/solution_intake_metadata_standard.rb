# frozen_string_literal: true

class SolutionIntakeMetadataStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_metadata
end
