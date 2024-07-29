# frozen_string_literal: true

class SolutionReportingLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :rprt_lvl
end
