# frozen_string_literal: true

class License < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :code_lcns
end
