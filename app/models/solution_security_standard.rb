# frozen_string_literal: true

class SolutionSecurityStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_sec
end
