# frozen_string_literal: true

class SolutionIntakeMaintenanceStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :maint
end
