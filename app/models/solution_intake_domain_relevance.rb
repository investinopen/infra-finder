# frozen_string_literal: true

class SolutionIntakeDomainRelevance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :fos
end
