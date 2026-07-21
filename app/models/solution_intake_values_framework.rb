# frozen_string_literal: true

class SolutionIntakeValuesFramework < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :values
end
