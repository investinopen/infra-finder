# frozen_string_literal: true

class SolutionCategoryDraftLink < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :soln_cat
end
