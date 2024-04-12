# frozen_string_literal: true

class AddCountsToOptions < ActiveRecord::Migration[7.1]
  TABLES = %i[
    board_structures
    business_forms
    community_governances
    hosting_strategies
    licenses
    maintenance_statuses
    primary_funding_sources
    readiness_levels
    solution_categories
    user_contributions
  ].freeze

  def change
    TABLES.each do |tbl|
      change_table tbl do |t|
        t.bigint :solutions_count, null: false, default: 0
        t.bigint :solution_drafts_count, null: false, default: 0
      end
    end
  end
end
