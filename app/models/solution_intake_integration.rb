# frozen_string_literal: true

class SolutionIntakeIntegration < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :integrations
end
