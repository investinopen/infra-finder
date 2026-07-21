# frozen_string_literal: true

class SolutionIntakeCommunityEngagementActivity < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :comm_eng
end
