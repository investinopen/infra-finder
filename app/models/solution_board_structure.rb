# frozen_string_literal: true

class SolutionBoardStructure < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :board
end
