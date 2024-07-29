# frozen_string_literal: true

class SolutionValuesFramework < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :values
end
