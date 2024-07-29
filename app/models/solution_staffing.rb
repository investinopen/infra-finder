# frozen_string_literal: true

class SolutionStaffing < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :staffing
end
