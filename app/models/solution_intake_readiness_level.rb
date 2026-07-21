# frozen_string_literal: true

class SolutionIntakeReadinessLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :tech_read
end
