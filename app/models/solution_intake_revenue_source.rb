# frozen_string_literal: true

class SolutionIntakeRevenueSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :rev_src
end
