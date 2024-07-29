# frozen_string_literal: true

class SolutionDraftPreservationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_pres
end
