# frozen_string_literal: true

class AccessCondition < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :access
end
