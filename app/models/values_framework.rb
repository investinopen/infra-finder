# frozen_string_literal: true

class ValuesFramework < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :values
end
