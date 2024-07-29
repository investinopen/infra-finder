# frozen_string_literal: true

class SolutionCategory < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :soln_cat
end
