# frozen_string_literal: true

class MaintenanceStatus < ApplicationRecord
  include ControlledVocabularyRecord

  scope :active, -> { with_providing(:active) }

  uses_vocab! :maint

  class << self
    # @return [<String>]
    def active_ids
      active.ids
    end
  end
end
