# frozen_string_literal: true

module Types
  # @see ControlledVocabularyRecord#provides
  class ControlledVocabularyProvisionType < Types::BaseEnum
    description <<~TEXT
    Special behavior a controlled vocabulary term provides in code, such as being the "Other" option.
    TEXT

    value "OTHER", value: "other" do
      description "The term is the \"Other\" option, paired with a free-text field."
    end

    value "UNKNOWN", value: "unknown" do
      description "The term means the answer is unknown."
    end

    value "NOT_APPLICABLE", value: "not_applicable" do
      description "The term means the property does not apply."
    end

    value "NONE", value: "none" do
      description "The term means none."
    end

    value "ACTIVE", value: "active" do
      description "The term means the solution is active."
    end

    value "APPLIES_TO_WEBSITE", value: "applies_to_website" do
      description "The term applies to the provider's website."
    end

    value "APPLIES_TO_SOLUTION", value: "applies_to_solution" do
      description "The term applies to the solution itself."
    end
  end
end
