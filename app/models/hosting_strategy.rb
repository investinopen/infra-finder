# frozen_string_literal: true

class HostingStrategy < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :saas

  auto_hide_provisions! :none, :not_applicable, :unknown
end
