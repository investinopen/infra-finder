# frozen_string_literal: true

class CommunityGovernance < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :gov_stat
end
