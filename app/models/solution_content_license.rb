# frozen_string_literal: true

class SolutionContentLicense < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :cont_lcns
end
