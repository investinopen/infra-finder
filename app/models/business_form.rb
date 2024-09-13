# frozen_string_literal: true

class BusinessForm < ApplicationRecord
  include ControlledVocabularyRecord

  NONPROFIT_TERMS = [
    "Fiscal sponsorship (academic institution)",
    "Fiscal sponsorship (non-profit)",
    "Non-profit organization",
    "Individual maintainer",
    "Volunteer community",
    "Intergovernmental organization",
  ].freeze

  uses_vocab! :bus_form

  scope :counts_for_nonprofit_operated, -> { where(term: NONPROFIT_TERMS) }

  def counts_for_nonprofit_operated?
    term.in?(NONPROFIT_TERMS)
  end
end
