# frozen_string_literal: true

class SolutionIntakeBoardStructure < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :board
end
