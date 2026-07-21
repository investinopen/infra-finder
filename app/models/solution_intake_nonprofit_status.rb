# frozen_string_literal: true

class SolutionIntakeNonprofitStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :nonprofit_status
end
