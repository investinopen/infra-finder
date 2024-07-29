# frozen_string_literal: true

class SolutionProgrammingLanguage < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :prgrm_lng
end
