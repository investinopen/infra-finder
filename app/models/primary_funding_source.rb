# frozen_string_literal: true

class PrimaryFundingSource < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :pr_fund
end
