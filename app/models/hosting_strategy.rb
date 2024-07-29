# frozen_string_literal: true

class HostingStrategy < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :saas
end
