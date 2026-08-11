# frozen_string_literal: true

class StatusCertification < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :status_certifications
end
