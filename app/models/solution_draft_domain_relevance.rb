# frozen_string_literal: true

class SolutionDraftDomainRelevance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :fos
end
