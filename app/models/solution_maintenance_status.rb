# frozen_string_literal: true

class SolutionMaintenanceStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :maint
end
