# frozen_string_literal: true

class SolutionDraftAccessCondition < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :access
end
