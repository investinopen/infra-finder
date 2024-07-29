# frozen_string_literal: true

class SolutionAuthenticationStandard < ApplicationRecord
  include ControlledVocabularyLink

  links_vocab_with_actual! :standards_auth
end
