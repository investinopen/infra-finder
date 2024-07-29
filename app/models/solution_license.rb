# frozen_string_literal: true

class SolutionLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :code_lcns
end
