# frozen_string_literal: true

class BusinessForm < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :bus_form
end
