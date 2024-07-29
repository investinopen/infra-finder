# frozen_string_literal: true

class SolutionDraftMaintenanceStatus < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :maint
end
