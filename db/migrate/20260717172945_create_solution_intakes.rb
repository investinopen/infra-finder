# frozen_string_literal: true

class CreateSolutionIntakes < ActiveRecord::Migration[7.1]
  def change
    create_enum :solution_intake_state, %w[pending in_review approved rejected]

    create_table :solution_intakes, id: :uuid do |t|
      t.references :provider, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.references :solution, null: true, foreign_key: { on_delete: :nullify }, type: :uuid, index: { unique: true }
      t.references :editor, null: true, foreign_key: { to_table: :users, on_delete: :nullify }, type: :uuid

      t.bigint :snowflake, null: false

      t.text :slug, null: false

      t.enum :contact_method, enum_type: :contact_method, null: false, default: :unavailable
      t.enum :state, enum_type: :solution_intake_state, null: false, default: :pending

      t.citext :name, null: false

      t.virtual :normalized_name, type: :citext, null: false, as: %[public.normalize_ransackable(name)], stored: true

      t.text :first_name
      t.text :last_name
      t.citext :email

      t.boolean :scoss, null: false, default: false
      t.boolean :shareholders, null: false, default: false

      t.date :founded_on
      t.bigint :member_count

      t.jsonb :logo_data

      t.decimal :current_staffing, precision: 19, scale: 2

      t.text :website
      t.text :contact
      t.text :board_members_url
      t.text :governance_summary
      t.text :membership_program_url
      t.text :research_organization_registry_url
      t.text :mission
      t.text :key_achievements
      t.text :organizational_history
      t.text :funding_needs
      t.text :service_summary

      t.text :financial_date_range
      t.date :financial_date_range_started_on
      t.date :financial_date_range_ended_on
      t.enum :financial_numbers_publishability, enum_type: :financial_numbers_publishability, null: false, default: :unknown
      t.enum :financial_information_scope, enum_type: :financial_information_scope, null: false, default: :unknown
      t.text :financial_numbers_documented_url

      t.jsonb :current_affiliations, null: false, default: []

      t.jsonb :founding_institutions, null: false, default: []

      t.jsonb :service_providers, null: false, default: []

      t.jsonb :recent_grants, null: false, default: []

      t.jsonb :top_granting_institutions, null: false, default: []

      t.enum :bylaws_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :bylaws, null: false, default: {}

      t.enum :code_of_conduct_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :code_of_conduct, null: false, default: {}

      t.enum :code_license_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :code_license, null: false, default: {}

      t.enum :code_repository_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :code_repository, null: false, default: {}

      t.enum :community_engagement_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :community_engagement, null: false, default: {}

      t.enum :equity_and_inclusion_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :equity_and_inclusion, null: false, default: {}

      t.enum :governance_records_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :governance_records, null: false, default: {}

      t.enum :governance_structure_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :governance_structure, null: false, default: {}

      t.enum :open_api_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :open_api, null: false, default: {}

      t.enum :open_data_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :open_data, null: false, default: {}

      t.enum :product_roadmap_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :product_roadmap, null: false, default: {}

      t.enum :pricing_implementation, enum_type: :pricing_implementation_status, null: false, default: :unknown
      t.jsonb :pricing, null: false, default: {}

      t.enum :privacy_policy_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :privacy_policy, null: false, default: {}

      t.enum :contribution_pathways_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :contribution_pathways, null: false, default: {}

      t.enum :user_documentation_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :user_documentation, null: false, default: {}

      t.enum :web_accessibility_implementation, enum_type: :implementation_status, null: false, default: :unknown
      t.jsonb :web_accessibility, null: false, default: {}

      t.citext :country_code
      t.citext :currency, null: false, default: "USD"
      t.bigint :annual_expenses_cents, null: false, default: 0
      t.bigint :annual_revenue_cents, null: false, default: 0
      t.bigint :investment_income_cents, null: false, default: 0
      t.bigint :other_revenue_cents, null: false, default: 0
      t.bigint :program_revenue_cents, null: false, default: 0
      t.bigint :total_assets_cents, null: false, default: 0
      t.bigint :total_contributions_cents, null: false, default: 0
      t.bigint :total_liabilities_cents, null: false, default: 0

      t.jsonb :free_inputs, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :snowflake, unique: true
      t.index :slug, unique: true
    end

    create_table :solution_intake_transitions, id: :uuid do |t|
      t.references :solution_intake, null: false, type: :uuid, foreign_key: { on_delete: :cascade }, index: false

      t.boolean :most_recent, null: false
      t.integer :sort_key, null: false

      t.enum :from_state, enum_type: :solution_intake_state, null: true

      t.enum :to_state, enum_type: :solution_intake_state, null: false

      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i(solution_intake_id sort_key), unique: true, name: "index_solution_intake_transitions_parent_sort"
      t.index %i(solution_intake_id most_recent), unique: true, where: "most_recent", name: "index_solution_intake_transitions_parent_most_recent"
    end
  end
end
