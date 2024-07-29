# frozen_string_literal: true

class SolutionNonprofitStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :nonprofit_status
end
