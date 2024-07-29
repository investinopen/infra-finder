# frozen_string_literal: true

class SolutionDraftNonprofitStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :nonprofit_status
end
