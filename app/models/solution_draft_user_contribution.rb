# frozen_string_literal: true

class SolutionDraftUserContribution < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :user_paths
end
