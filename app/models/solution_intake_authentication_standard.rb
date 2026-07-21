# frozen_string_literal: true

class SolutionIntakeAuthenticationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_intake! :standards_auth
end
