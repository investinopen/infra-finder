# frozen_string_literal: true

class SolutionDraftBusinessForm < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :bus_form
end
