# frozen_string_literal: true

class SolutionMetadataStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_metadata
end
