# frozen_string_literal: true

class SolutionPrimaryFundingSource < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :pr_fund
end
