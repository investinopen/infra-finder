# frozen_string_literal: true

class SolutionIntakeUserContribution < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :user_paths
end
