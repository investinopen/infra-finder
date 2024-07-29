# frozen_string_literal: true

class NonprofitStatus < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :nonprofit_status
end
