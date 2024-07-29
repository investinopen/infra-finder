# frozen_string_literal: true

class UserContribution < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :user_paths
end
