# frozen_string_literal: true

class SolutionIntakeStatusCertification < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :status_certifications
end
