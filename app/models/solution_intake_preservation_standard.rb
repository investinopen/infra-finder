# frozen_string_literal: true

class SolutionIntakePreservationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_pres
end
