# frozen_string_literal: true

class SolutionDraftContentLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :cont_lcns
end
