# frozen_string_literal: true

class SolutionAccessCondition < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :access
end
