# frozen_string_literal: true

class SolutionIntakeProgrammingLanguage < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :prgrm_lng
end
