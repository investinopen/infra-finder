# frozen_string_literal: true

class SolutionDraftProgrammingLanguage < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :prgrm_lng
end
