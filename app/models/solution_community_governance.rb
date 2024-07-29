# frozen_string_literal: true

class SolutionCommunityGovernance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :gov_stat
end
