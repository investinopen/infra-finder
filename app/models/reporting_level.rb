# frozen_string_literal: true

class ReportingLevel < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :rprt_lvl
end
