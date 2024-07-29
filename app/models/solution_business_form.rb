# frozen_string_literal: true

class SolutionBusinessForm < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :bus_form
end
