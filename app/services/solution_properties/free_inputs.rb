# frozen_string_literal: true

module SolutionProperties
  # A store model that encapsulates free inputs and stores them on the record.
  class FreeInputs
    include Support::EnhancedStoreModel

    strip_attributes allow_empty: false, collapse_spaces: true, replace_newlines: false

    attribute :authentication_standard_other, :string

    attribute :board_level_other, :string

    attribute :board_structure_other, :string

    attribute :business_form_other, :string

    attribute :community_engagement_activity_other, :string

    attribute :content_license_other, :string

    attribute :current_affiliation_free_input, :string

    attribute :financial_reporting_level_other, :string

    attribute :founding_institution_free_input, :string

    attribute :integration_other, :string

    attribute :license_other, :string

    attribute :metadata_standard_other, :string

    attribute :metrics_standard_other, :string

    attribute :persistent_identifier_standard_other, :string

    attribute :preservation_standard_other, :string

    attribute :primary_funding_source_other, :string

    attribute :programming_language_other, :string

    attribute :recent_grant_free_input, :string

    attribute :registry_free_input, :string

    attribute :revenue_source_other, :string

    attribute :security_standard_other, :string

    attribute :service_provider_free_input, :string

    attribute :top_granting_institution_free_input, :string

    attribute :user_contribution_other, :string
  end
end
