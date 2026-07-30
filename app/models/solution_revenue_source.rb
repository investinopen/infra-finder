# frozen_string_literal: true

class SolutionRevenueSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :rev_src
end
