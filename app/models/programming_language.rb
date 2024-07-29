# frozen_string_literal: true

class ProgrammingLanguage < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :prgrm_lng
end
