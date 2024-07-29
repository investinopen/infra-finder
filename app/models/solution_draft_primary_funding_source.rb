# frozen_string_literal: true

class SolutionDraftPrimaryFundingSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :pr_fund
end
