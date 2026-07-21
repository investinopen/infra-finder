# frozen_string_literal: true

class SolutionIntakeAccessibilityScope < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :acc_scope
end
