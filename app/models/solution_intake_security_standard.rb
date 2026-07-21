# frozen_string_literal: true

class SolutionIntakeSecurityStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_sec
end
