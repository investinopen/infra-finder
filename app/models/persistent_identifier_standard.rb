# frozen_string_literal: true

class PersistentIdentifierStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_pids
end
