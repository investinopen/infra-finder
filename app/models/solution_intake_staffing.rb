# frozen_string_literal: true

class SolutionIntakeStaffing < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :staffing
end
