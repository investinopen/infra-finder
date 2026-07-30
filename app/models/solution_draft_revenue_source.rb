# frozen_string_literal: true

class SolutionDraftRevenueSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :rev_src
end
