# frozen_string_literal: true

class SolutionDomainRelevance < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :fos
end
