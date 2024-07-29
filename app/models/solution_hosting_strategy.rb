# frozen_string_literal: true

class SolutionHostingStrategy < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :saas
end
