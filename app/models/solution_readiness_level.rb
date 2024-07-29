# frozen_string_literal: true

class SolutionReadinessLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :tech_read
end
