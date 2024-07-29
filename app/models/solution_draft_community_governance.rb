# frozen_string_literal: true

class SolutionDraftCommunityGovernance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :gov_stat
end
