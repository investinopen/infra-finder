# frozen_string_literal: true

class AddNewSolutionProperties < ActiveRecord::Migration[7.1]
  TABLES = %i[
    solutions
    solution_drafts
    solution_intakes
  ].freeze

  def change
    add_controlled_vocabulary :access_conditions
    add_controlled_vocabulary :domain_relevances
    add_controlled_vocabulary :revenue_sources

    TABLES.each do |table|
      change_table table do |t|
        t.text :fiscal_host, null: true
        t.jsonb :registries, null: false, default: []
      end
    end
  end

  private

  def add_controlled_vocabulary(name, vocab_table_name: name.to_s.pluralize.to_sym, vocab_assoc: name.to_s.singularize.to_sym)
    create_controlled_vocabulary_table(vocab_table_name)

    TABLES.each do |solutionish_table|
      solutionish_assoc = solutionish_table.to_s.singularize.to_sym

      table_name = "#{solutionish_assoc}_#{vocab_table_name}".to_sym

      create_controlled_vocabulary_join_table(table_name, solutionish_assoc:, vocab_assoc:)
    end
  end

  def create_controlled_vocabulary_join_table(table_name, solutionish_assoc:, vocab_assoc:)
    solutionish_id = :"#{solutionish_assoc}_id"
    vocab_assoc_id = :"#{vocab_assoc}_id"

    create_table table_name, id: :uuid do |t|
      t.references solutionish_assoc, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references vocab_assoc, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.boolean :single, null: false, default: false
      t.citext :assoc, null: false

      t.index [solutionish_id, vocab_assoc_id, :assoc], unique: true,
        where: %[NOT single],
        name: "udx_#{table_name}_multi"

      t.index [solutionish_id, :assoc], unique: true,
        where: %[single],
        name: "udx_#{table_name}_single"

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end

  def create_controlled_vocabulary_table(table_name)
    create_table table_name, id: :uuid do |t|
      t.enum :visibility, enum_type: :visibility, null: false, default: "hidden"
      t.enum :provides, enum_type: :controlled_vocabulary_provision, null: true

      t.bigint :bespoke_filter_position, null: true

      t.citext :name, null: false, collation: "custom_numeric"
      t.citext :slug, null: false
      t.citext :term, null: false, collation: "custom_numeric"
      t.citext :enforced_slug, null: true

      t.text :description, null: true

      t.bigint :solutions_count, null: false
      t.bigint :solution_drafts_count, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :slug, unique: true
      t.index :term, unique: true
      t.index :provides

      t.index %i[bespoke_filter_position term],
        name: "index_#{table_name}_bespoke_filter_ordering"
    end
  end
end
