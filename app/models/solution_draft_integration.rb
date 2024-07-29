# frozen_string_literal: true

class SolutionDraftIntegration < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :integrations
end
