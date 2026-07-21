# frozen_string_literal: true

class SolutionIntakeContentLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :cont_lcns
end
