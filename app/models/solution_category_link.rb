# frozen_string_literal: true

class SolutionCategoryLink < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :soln_cat
end
