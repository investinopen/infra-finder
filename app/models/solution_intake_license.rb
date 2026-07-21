# frozen_string_literal: true

class SolutionIntakeLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :code_lcns
end
