# frozen_string_literal: true

class SolutionIntakeAccessCondition < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :access
end
