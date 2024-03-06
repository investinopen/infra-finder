# frozen_string_literal: true

class AddMissingFieldsToSolutionsAndDrafts < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  def change
    TABLES.each do |table|
      change_table table do |t|
        t.text :engagement_with_values_frameworks, null: true
        t.text :service_summary, null: true

        implementation_for!(:code_license, t:)

        t.jsonb :recent_grants, null: false, default: []
        t.jsonb :top_granting_institutions, null: false, default: []
      end
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TYPE solution_implementation ADD VALUE IF NOT EXISTS 'code_license' AFTER 'bylaws';
        SQL
      end
    end
  end

  def implementation_for!(name, t:)
    t.enum :"#{name}_implementation", enum_type: :implementation_status, null: false, default: :unknown

    t.jsonb name, null: false, default: {}
  end
end
