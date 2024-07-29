# frozen_string_literal: true

class SolutionDraftLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :code_lcns
end
