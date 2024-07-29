# frozen_string_literal: true

class SolutionDraftSecurityStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_sec
end
