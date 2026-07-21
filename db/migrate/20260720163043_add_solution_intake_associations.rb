# frozen_string_literal: true

class AddSolutionIntakeAssociations < ActiveRecord::Migration[7.1]
  def change
    create_intake_association_table :solution_category_intake_links, :solution_category
    create_intake_association_table :solution_intake_accessibility_scopes, :accessibility_scope
    create_intake_association_table :solution_intake_authentication_standards, :authentication_standard
    create_intake_association_table :solution_intake_board_structures, :board_structure
    create_intake_association_table :solution_intake_business_forms, :business_form
    create_intake_association_table :solution_intake_community_engagement_activities, :community_engagement_activity
    create_intake_association_table :solution_intake_community_governances, :community_governance
    create_intake_association_table :solution_intake_content_licenses, :content_license
    create_intake_association_table :solution_intake_hosting_strategies, :hosting_strategy
    create_intake_association_table :solution_intake_integrations, :integration
    create_intake_association_table :solution_intake_licenses, :license
    create_intake_association_table :solution_intake_maintenance_statuses, :maintenance_status
    create_intake_association_table :solution_intake_metadata_standards, :metadata_standard
    create_intake_association_table :solution_intake_metrics_standards, :metrics_standard
    create_intake_association_table :solution_intake_nonprofit_statuses, :nonprofit_status
    create_intake_association_table :solution_intake_persistent_identifier_standards, :persistent_identifier_standard
    create_intake_association_table :solution_intake_preservation_standards, :preservation_standard
    create_intake_association_table :solution_intake_primary_funding_sources, :primary_funding_source
    create_intake_association_table :solution_intake_programming_languages, :programming_language
    create_intake_association_table :solution_intake_readiness_levels, :readiness_level
    create_intake_association_table :solution_intake_reporting_levels, :reporting_level
    create_intake_association_table :solution_intake_security_standards, :security_standard
    create_intake_association_table :solution_intake_staffings, :staffing
    create_intake_association_table :solution_intake_user_contributions, :user_contribution
    create_intake_association_table :solution_intake_values_frameworks, :values_framework
  end

  private

  def create_intake_association_table(table_name, association_name)
    association_id = "#{association_name}_id".to_sym

    create_table table_name, id: :uuid do |t|
      t.references :solution_intake, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references association_name, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.boolean :single, null: false, default: false
      t.citext :assoc, null: false

      t.index [:solution_intake_id, association_id, :assoc], unique: true,
        where: %[NOT single],
        name: "udx_#{table_name}_multi"

      t.index %i[solution_intake_id assoc], unique: true,
        where: %[single],
        name: "udx_#{table_name}_single"

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
