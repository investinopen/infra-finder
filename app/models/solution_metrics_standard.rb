# frozen_string_literal: true

class SolutionMetricsStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_metrics
end
