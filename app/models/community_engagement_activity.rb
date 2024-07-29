# frozen_string_literal: true

class CommunityEngagementActivity < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :comm_eng
end
