# frozen_string_literal: true

class SolutionUserContribution < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :user_paths
end
