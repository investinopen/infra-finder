# frozen_string_literal: true

class SolutionIntakeMetricsStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_metrics
end
