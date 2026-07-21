# frozen_string_literal: true

class SolutionCategoryIntakeLink < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :soln_cat
end
