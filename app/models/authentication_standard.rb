# frozen_string_literal: true

class AuthenticationStandard < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :standards_auth
end
