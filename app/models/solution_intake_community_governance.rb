# frozen_string_literal: true

class SolutionIntakeCommunityGovernance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :gov_stat
end
