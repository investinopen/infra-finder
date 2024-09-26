# frozen_string_literal: true

class AccessibilityScope < ApplicationRecord
  include ControlledVocabularyRecord

  uses_vocab! :acc_scope

  def applies_to_solution?
    provides == "applies_to_solution"
  end

  def applies_to_website?
    provides == "applies_to_website"
  end
end
