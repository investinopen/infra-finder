# frozen_string_literal: true

class SolutionDraftHostingStrategy < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :saas
end
