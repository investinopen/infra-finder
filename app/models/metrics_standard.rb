# frozen_string_literal: true

class MetricsStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_metrics
end
