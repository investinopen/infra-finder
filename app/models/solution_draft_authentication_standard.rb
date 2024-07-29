# frozen_string_literal: true

class SolutionDraftAuthenticationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :standards_auth
end
