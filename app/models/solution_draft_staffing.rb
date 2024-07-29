# frozen_string_literal: true

class SolutionDraftStaffing < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :staffing
end
