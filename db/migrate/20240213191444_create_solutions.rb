# frozen_string_literal: true

class CreateSolutions < ActiveRecord::Migration[7.1]
  def change
    create_enum :contact_method, %w[unavailable email website]

    create_enum :financial_information_scope, %w[unknown not_applicable project host]
    create_enum :financial_numbers_applicability, %w[unknown not_applicable applicable]
    create_enum :financial_numbers_publishability, %w[unknown not_applicable unapproved approved]

    create_table :solutions, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :restrict }, type: :uuid

      t.references :board_structure, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :business_form, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :community_governance, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :hosting_strategy, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :maintenance_status, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :primary_funding_source, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :readiness_level, null: true, type: :uuid, foreign_key: { on_delete: :restrict }

      t.citext :identifier, null: false, default: proc { "gen_random_uuid()::citext" }
      t.enum :contact_method, enum_type: :contact_method, null: false, default: :unavailable
      t.citext :slug, null: false

      # Core
      t.citext :name, null: false
      t.date :founded_on
      t.text :location_of_incorporation
      t.bigint :member_count
      t.decimal :current_staffing

      # Contact
      t.text :website
      t.text :contact
      t.text :research_organization_registry_url

      # Blurbs
      t.text :mission
      t.text :key_achievements
      t.text :organizational_history
      t.text :funding_needs
      t.text :governance_summary

      # Free Inputs
      t.text :content_licensing
      t.text :special_certifications_or_statuses
      t.text :standards_employed
      t.text :what_registered
      t.text :what_technologies
      t.text :what_other_tools

      # Finances
      t.bigint :annual_expenses
      t.bigint :annual_revenue
      t.bigint :investment_income
      t.bigint :other_revenue
      t.bigint :program_revenue
      t.bigint :total_assets
      t.bigint :total_contributions
      t.bigint :total_liabilities

      t.enum :financial_numbers_applicability, enum_type: :financial_numbers_applicability, null: false, default: :unknown
      t.enum :financial_numbers_publishability, enum_type: :financial_numbers_publishability, null: false, default: :unknown
      t.enum :financial_information_scope, enum_type: :financial_information_scope, null: false, default: :unknown
      t.text :financial_numbers_documented_url

      # Store model lists
      t.jsonb :comparable_products, null: false, default: []
      t.jsonb :current_affiliations, null: false, default: []
      t.jsonb :founding_institutions, null: false, default: []
      t.jsonb :service_providers, null: false, default: []

      # Implementations
      implementation_for!(:bylaws, t:)
      implementation_for!(:code_of_conduct, t:)
      implementation_for!(:code_repository, t:)
      implementation_for!(:community_engagement, t:)
      implementation_for!(:equity_and_inclusion, t:)
      implementation_for!(:governance_activities, t:)
      implementation_for!(:governance_structure, t:)
      implementation_for!(:open_api, t:)
      implementation_for!(:open_data, t:)
      implementation_for!(:product_roadmap, t:)
      implementation_for!(:pricing, t:)
      implementation_for!(:privacy_policy, t:)
      implementation_for!(:user_contribution_pathways, t:)
      implementation_for!(:user_documentation, t:)
      implementation_for!(:web_accessibility, t:)

      # Attachments
      t.jsonb :logo_data

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :slug, unique: true
      t.index :identifier, unique: true
    end
  end

  private

  def implementation_for!(name, t:)
    t.enum :"#{name}_implementation", enum_type: :implementation_status, null: false, default: :unknown

    t.jsonb name, null: false, default: {}
  end
end
