# frozen_string_literal: true

class RevenueSource < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :rev_src
end
