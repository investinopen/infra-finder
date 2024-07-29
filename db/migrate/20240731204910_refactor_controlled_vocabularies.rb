# frozen_string_literal: true

class RefactorControlledVocabularies < ActiveRecord::Migration[7.1]
  SINGLE_TABLES = %i[
    board_structures
    business_forms
    community_governances
    hosting_strategies
    maintenance_statuses
    primary_funding_sources
    readiness_levels
  ].freeze

  MULTI_TABLES = %i[
    licenses
    solution_categories
    user_contributions
  ].freeze

  EXISTING = (SINGLE_TABLES | MULTI_TABLES).sort.freeze

  NEEDS_VISIBLITY = EXISTING.without(:hosting_strategies, :maintenance_statuses)

  NEW_MAPPING = {
    acc_scope: :accessibility_scopes,
    comm_eng: :community_engagement_activities,
    cont_lcns: :content_licenses,
    integrations: :integrations,
    nonprofit_status: :nonprofit_statuses,
    prgrm_lng: :programming_languages,
    rprt_lvl: :reporting_levels,
    staffing: :staffings,
    standards_auth: :authentication_standards,
    standards_metadata: :metadata_standards,
    standards_metrics: :metrics_standards,
    standards_pids: :persistent_identifier_standards,
    standards_pres: :preservation_standards,
    standards_sec: :security_standards,
    values: :values_frameworks,
  }.freeze

  NEW_TABLES = NEW_MAPPING.values.freeze

  SINGLE_TO_MULTI = %i[
    business_forms
    board_structures
    community_governances
    maintenance_statuses
    primary_funding_sources
    readiness_levels
  ].freeze

  KEEP_SINGLE = %i[
    hosting_strategies
  ].freeze

  SOURCES = %i[
    solutions
    solution_drafts
  ].freeze

  LANG = "SQL"

  def change
    add_staffing_fn!

    prepare_existing!

    repopulate_maintenance_statuses!

    add_new_tables!

    adjust_existing_link_tables!

    add_link_tables_for_existing_singular_options!
  end

  private

  def add_staffing_fn!
    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc
        CREATE FUNCTION public.calculate_staffing_range(min_value int, max_value int) RETURNS int4range AS $$
        SELECT CASE
        WHEN $1 IS NOT NULL OR $2 IS NOT NULL THEN int4range($1, $2, '[)')
        ELSE
          NULL
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL
      end

      dir.down do
        execute <<~SQL.strip_heredoc
        DROP FUNCTION public.calculate_staffing_range(int, int);
        SQL
      end
    end
  end

  def add_new_tables!
    NEW_TABLES.each do |table|
      create_controlled_vocabulary_record(table) do |t|
        if table == :staffings
          t.integer :min_value
          t.integer :max_value
          t.virtual :coverage, type: :int4range, null: true, as: %[public.calculate_staffing_range(min_value, max_value)], stored: true

          t.index :coverage, using: :gist
        end
      end
    end

    linkages_for(NEW_TABLES) do |linkage|
      create_controlled_vocabulary_link(linkage)
    end
  end

  def add_visibility_column_to!(table)
    change_table table do |t|
      t.enum :visibility, enum_type: "visibility", null: false, default: "hidden"
    end

    on_up do
      say_with_time "Marking all existing records in #{table} visible" do
        exec_update <<~SQL.strip_heredoc
        UPDATE #{table} SET visibility = 'visible';
        SQL
      end
    end
  end

  def adjust_existing_link_tables!
    linkages_for(MULTI_TABLES) do |linkage|
      remove_index linkage.link_table_name, column: [linkage.source_id, linkage.target_id], name: linkage.indices.old_uniqueness_name, unique: true

      change_table linkage.link_table_name do |t|
        t.boolean :single, null: false, default: false
        t.citext :assoc

        t.index linkage.indices.multi_uniqueness_columns, **linkage.indices.multi_uniqueness_options
        t.index linkage.indices.single_uniqueness_columns, **linkage.indices.single_uniqueness_options
      end

      on_up do
        say_with_time "Adding #{linkage.link_table_name} assoc values" do
          exec_update(<<~SQL.strip_heredoc)
          UPDATE #{linkage.link_table_name} SET assoc = #{linkage.quoted_target};
          SQL
        end
      end

      change_column_null linkage.link_table_name, :assoc, false
    end
  end

  def add_link_tables_for_existing_singular_options!
    linkages_for(SINGLE_TABLES) do |linkage|
      migrate_single_options_for! linkage
    end
  end

  def migrate_single_options_for!(linkage)
    linkage => { link_table_name:, source:, source_id:, target_id:, phase_1_target_id:, }

    change_table source do |t|
      t.rename target_id, phase_1_target_id

      if target_id == :maintenance_status_id
        t.rename :maintenance_status, :phase_1_maintenance_status
      end
    end

    create_controlled_vocabulary_link(linkage)

    on_up do
      if linkage.target == :maintenance_statuses
        say_with_time "Migrating #{link_table_name} based on enum value" do
          exec_update(<<~SQL)
          WITH tuples AS (
            SELECT src.id AS #{source_id},
              ms.id AS #{target_id},
              'maintenance_statuses' AS assoc
              FROM #{source} AS src
              INNER JOIN maintenance_statuses ms ON ms.provides = src.phase_1_maintenance_status::text
          )
          INSERT INTO #{link_table_name} (#{source_id}, #{target_id}, assoc)
          SELECT #{source_id}, #{target_id}, assoc FROM tuples;
          SQL
        end
      elsif linkage.single_link?
        say_with_time "Migrating #{link_table_name} singular records" do
          exec_update(<<~SQL)
          WITH tuples AS (
            SELECT src.id AS #{source_id},
              src.#{phase_1_target_id} AS #{target_id}
              FROM #{source} AS src
              WHERE #{phase_1_target_id} IS NOT NULL
          )
          INSERT INTO #{link_table_name} (#{source_id}, #{target_id}, assoc, single)
          SELECT #{source_id}, #{target_id}, #{linkage.migrated_assoc}, TRUE FROM tuples;
          SQL
        end
      else
        say_with_time "Migrating #{link_table_name} into multi-records" do
          exec_update(<<~SQL)
          WITH tuples AS (
            SELECT src.id AS #{source_id},
              src.#{phase_1_target_id} AS #{target_id}
              FROM #{source} AS src
              WHERE #{phase_1_target_id} IS NOT NULL
          )
          INSERT INTO #{link_table_name} (#{source_id}, #{target_id}, assoc, single)
          SELECT #{source_id}, #{target_id}, #{linkage.migrated_assoc}, FALSE FROM tuples;
          SQL
        end
      end
    end
  end

  def enhance_existing_table!(table)
    change_table table do |t|
      t.citext :term
      t.citext :enforced_slug
      t.citext :provides

      t.index :term, unique: true
      t.index :provides
    end

    on_up do
      say_with_time "Migrating #{table} name => term" do
        exec_update <<~SQL.strip_heredoc
        UPDATE #{table} SET term = name;
        SQL
      end
    end

    change_column_null table, :term, false
  end

  def prepare_existing!
    one_off_fixes!

    NEEDS_VISIBLITY.each do |table|
      add_visibility_column_to! table
    end

    EXISTING.each do |table|
      enhance_existing_table! table
    end
  end

  def one_off_fixes!
    on_up do
      say_with_time "Maybe correcting name of standard solution category" do
        exec_update <<~SQL.strip_heredoc
        UPDATE solution_categories SET name = 'Standard, specification or protocol'
        WHERE name = 'Standard, specification, or protocol';
        SQL
      end
    end
  end

  def create_controlled_vocabulary_record(table_name)
    create_table table_name, id: :uuid do |t|
      t.citext :name, null: false
      t.citext :slug, null: false
      t.citext :term, null: false
      t.citext :provides
      t.text :enforced_slug
      t.text :description
      t.enum :visibility, enum_type: "visibility", null: false, default: "hidden"

      t.bigint :solutions_count, null: false, default: 0
      t.bigint :solution_drafts_count, null: false, default: 0

      yield t if block_given?

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :provides
      t.index :slug, unique: true
      t.index :term, unique: true
    end
  end

  def create_controlled_vocabulary_link(linkage)
    create_table linkage.link_table_name, id: :uuid do |t|
      t.references linkage.source_reference, foreign_key: { on_delete: :cascade }, null: false, type: :uuid
      t.references linkage.target_reference, foreign_key: { on_delete: :cascade }, null: false, type: :uuid
      t.boolean :single, null: false, default: false
      t.citext :assoc, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index linkage.indices.multi_uniqueness_columns, **linkage.indices.multi_uniqueness_options
      t.index linkage.indices.single_uniqueness_columns, **linkage.indices.single_uniqueness_options
    end
  end

  # We are converting back from an enum.
  # @return [void]
  def repopulate_maintenance_statuses!
    on_up do
      say_with_time "repopulating maintenance_statuses" do
        exec_update(<<~SQL.strip_heredoc)
        INSERT INTO maintenance_statuses (name, slug, term, enforced_slug, provides, visibility)
        VALUES
          ('Actively Maintained', 'actively-maintained', 'Actively Maintained', 'actively-maintained', 'active', 'visible'),
          ('Minimally Maintained', 'minimally-maintained', 'Minimally Maintained', 'minimally-maintained', NULL, 'hidden'),
          ('Unsupported', 'unsupported', 'Unsupported', 'unsupported', NULL, 'hidden'),
          ('Unknown', 'unknown', 'Unknown', 'unknown', 'unknown', 'hidden')
        ON CONFLICT (slug) DO UPDATE SET
          name = EXCLUDED.name,
          term = EXCLUDED.term,
          enforced_slug = EXCLUDED.enforced_slug,
          provides = EXCLUDED.provides,
          visibility = EXCLUDED.visibility
        ;
        SQL
      end
    end
  end

  def linkages_for(*targets, &)
    return enum_for(__method__) unless block_given?

    targets.flatten!

    SOURCES.product(targets).map do |(source, target)|
      Linkage.new(source:, target:).tap(&)
    end
  end

  def on_up(&)
    reversible do |dir|
      dir.up(&)
    end
  end

  class Linkage < Support::FlexibleStruct
    include Dry::Core::Memoizable

    attribute :source, Support::Types::Coercible::Symbol
    attribute :target, Support::Types::Coercible::Symbol

    delegate :foreign_key, :id, :reference, to: :source_table_ref, prefix: :source
    delegate :foreign_key, :id, :reference, to: :target_table_ref, prefix: :target

    memoize def link_table_name
      if target == :solution_categories
        if source == :solution_drafts
          :solution_category_draft_links
        else
          :solution_category_links
        end
      else
        :"#{source_reference}_#{target}"
      end
    end

    memoize def indices
      Indices.new(linkage: self)
    end

    memoize def source_table_ref
      TableReference.new(name: source)
    end

    memoize def target_table_ref
      TableReference.new(name: target)
    end

    memoize def phase_1_target_id
      :"phase_1_#{target_id}"
    end

    def migrated_assoc
      if single_link?
        quote target_reference
      else
        quoted_target
      end
    end

    def quoted_source
      quote source
    end

    def quoted_target
      quote target
    end

    def single_link?
      target.in?(KEEP_SINGLE)
    end

    private

    def quote(value)
      ApplicationRecord.connection.quote(value)
    end
  end

  class Indices < Support::FlexibleStruct
    include Dry::Core::Memoizable

    attribute :linkage, Linkage

    delegate_missing_to :linkage

    memoize def multi_uniqueness_columns
      [source_id, target_id, :assoc]
    end

    memoize def multi_uniqueness_options
      {
        name: multi_uniqueness_name,
        unique: true,
        where: %[NOT single],
      }
    end

    memoize def multi_uniqueness_name
      "udx_#{link_table_name}_multi"
    end

    memoize def single_uniqueness_columns
      [source_id, :assoc]
    end

    memoize def single_uniqueness_options
      {
        name: single_uniqueness_name,
        unique: true,
        where: %[single],
      }
    end

    memoize def single_uniqueness_name
      "udx_#{link_table_name}_single"
    end

    memoize def old_uniqueness_name
      if source == :solutions && target == :solution_categories
        "index_solution_category_link_uniqueness"
      else
        "index_#{link_table_name}_uniqueness"
      end
    end
  end

  class TableReference < Support::FlexibleStruct
    include Dry::Core::Memoizable

    attribute :name, Support::Types::Coercible::Symbol

    memoize def foreign_key
      :"#{name.to_s.singularize}_id"
    end

    alias id foreign_key

    memoize def reference
      :"#{name.to_s.singularize}"
    end
  end
end
