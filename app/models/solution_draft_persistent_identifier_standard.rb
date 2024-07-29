# frozen_string_literal: true

class SolutionDraftPersistentIdentifierStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_pids
end
