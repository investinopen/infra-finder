# frozen_string_literal: true

class SolutionDraftMetricsStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_metrics
end
