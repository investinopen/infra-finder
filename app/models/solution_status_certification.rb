# frozen_string_literal: true

class SolutionStatusCertification < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :status_certifications
end
