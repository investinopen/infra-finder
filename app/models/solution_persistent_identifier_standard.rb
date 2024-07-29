# frozen_string_literal: true

class SolutionPersistentIdentifierStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_pids
end
