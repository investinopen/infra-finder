# frozen_string_literal: true

class ContentLicense < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :cont_lcns
end
