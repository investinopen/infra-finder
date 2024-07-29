# frozen_string_literal: true

class SolutionIntegration < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :integrations
end
