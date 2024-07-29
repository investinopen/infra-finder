# frozen_string_literal: true

class AccessibilityScope < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :acc_scope
end
