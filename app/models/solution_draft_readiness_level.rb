# frozen_string_literal: true

class SolutionDraftReadinessLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :tech_read
end
