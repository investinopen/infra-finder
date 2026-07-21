# frozen_string_literal: true

class SolutionIntakeBusinessForm < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :bus_form
end
