# frozen_string_literal: true

class SolutionDraftBoardStructure < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :board
end
