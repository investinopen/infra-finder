# frozen_string_literal: true

class SolutionPreservationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_pres
end
