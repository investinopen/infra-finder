# frozen_string_literal: true

class SolutionDraftAccessibilityScope < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :acc_scope
end
