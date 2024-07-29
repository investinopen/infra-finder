# frozen_string_literal: true

class BoardStructure < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :board
end
