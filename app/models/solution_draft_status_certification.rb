# frozen_string_literal: true

class SolutionDraftStatusCertification < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_draft! :status_certifications
end
