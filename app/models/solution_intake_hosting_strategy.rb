# frozen_string_literal: true

class SolutionIntakeHostingStrategy < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :saas
end
