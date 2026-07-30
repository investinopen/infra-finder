# frozen_string_literal: true

class DomainRelevance < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :fos
end
