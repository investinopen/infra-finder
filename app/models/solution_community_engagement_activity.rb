# frozen_string_literal: true

class SolutionCommunityEngagementActivity < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :comm_eng
end
