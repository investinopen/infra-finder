# frozen_string_literal: true

class SolutionIntakePersistentIdentifierStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_pids
end
