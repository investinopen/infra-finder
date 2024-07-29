# frozen_string_literal: true

class SolutionDraftValuesFramework < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :values
end
