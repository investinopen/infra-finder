# frozen_string_literal: true

class SolutionIntakeReportingLevel < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :rprt_lvl
end
