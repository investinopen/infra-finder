# frozen_string_literal: true

class SolutionAccessibilityScope < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :acc_scope
end
