# frozen_string_literal: true

class SecurityStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_sec
end
