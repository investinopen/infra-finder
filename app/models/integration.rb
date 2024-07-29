# frozen_string_literal: true

class Integration < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :integrations
end
