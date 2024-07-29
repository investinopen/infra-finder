# frozen_string_literal: true

class SolutionDraftReportingLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :rprt_lvl
end
