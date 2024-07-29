# frozen_string_literal: true

class MaintenanceStatus < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :maint
end
