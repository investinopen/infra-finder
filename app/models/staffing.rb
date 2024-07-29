# frozen_string_literal: true

class Staffing < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :staffing
end
