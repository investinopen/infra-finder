# frozen_string_literal: true

class ReadinessLevel < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :tech_read
end
