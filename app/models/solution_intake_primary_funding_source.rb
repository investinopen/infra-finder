# frozen_string_literal: true

class SolutionIntakePrimaryFundingSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :pr_fund
end
