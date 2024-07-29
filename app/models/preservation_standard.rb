# frozen_string_literal: true

class PreservationStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_pres
end
