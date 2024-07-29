# frozen_string_literal: true

class SolutionDraftCommunityEngagementActivity < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :comm_eng
end
