# frozen_string_literal: true

class AdjustMoreNewColumns < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  BLURBS_TO_DEPRECATE = %i[
    content_licensing
    engagement_with_values_frameworks
    integrations_and_compatibility
    technology_dependencies
  ].freeze

  def change
    create_enum :solution_kind, %i[actual draft]

    rename_solution_implementation!

    rename_implementations!

    migrate_pricing_implementation!

    add_new_fields!

    deprecate_phase_1_blurbs!

    migrate_old_blurbs_to_free_inputs!
  end

  private

  def add_new_fields!
    TABLES.each do |table|
      add_new_fields_for! table
    end
  end

  def add_new_fields_for!(table)
    change_table table do |t|
      t.text :board_members_url
      t.text :financial_date_range
      t.date :financial_date_range_started_on
      t.date :financial_date_range_ended_on
      t.text :membership_program_url
      t.boolean :scoss, null: false, default: false
      t.boolean :shareholders, null: false, default: false
      t.jsonb :free_inputs, null: false, default: {}
    end
  end

  def deprecate_phase_1_blurbs!
    TABLES.each do |table|
      change_table table do |t|
        BLURBS_TO_DEPRECATE.each do |blurb|
          t.rename blurb, :"phase_1_#{blurb}"
        end
      end
    end
  end

  def migrate_old_blurbs_to_free_inputs!
    reversible do |dir|
      dir.up do
        TABLES.each do |table|
          say_with_time "Migrating converted free inputs for #{table} blurbs" do
            exec_update(<<~SQL.strip_heredoc.strip)
            UPDATE #{table} SET free_inputs = free_inputs || jsonb_build_object(
              'community_engagement_activity_other', phase_1_engagement_with_values_frameworks,
              'content_license_other', phase_1_content_licensing,
              'integration_other', phase_1_integrations_and_compatibility
            );
            SQL
          end
        end
      end
    end
  end

  def migrate_pricing_implementation!
    create_enum :pricing_implementation_status, %w[available in_progress considering not_planning no_direct_costs unknown]

    TABLES.each do |table|
      migrate_pricing_implementation_for! table
    end
  end

  def migrate_pricing_implementation_for!(table)
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation DROP DEFAULT;
        SQL
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation SET DATA TYPE pricing_implementation_status USING
        CASE pricing_implementation
        WHEN 'not_applicable' THEN 'no_direct_costs'::pricing_implementation_status
        ELSE
          pricing_implementation::text::pricing_implementation_status
        END
        SQL
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation SET DEFAULT 'unknown'::pricing_implementation_status;
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation DROP DEFAULT;
        SQL
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation SET DATA TYPE implementation_status USING
        CASE pricing_implementation
        WHEN 'no_direct_costs' THEN 'not_applicable'::implementation_status
        ELSE
          pricing_implementation::text::implementation_status
        END
        SQL
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN pricing_implementation SET DEFAULT 'unknown'::implementation_status;
        SQL
      end
    end
  end

  def rename_solution_implementation!
    rename_enum "solution_implementation", "implementation_name"
  end

  def rename_implementations!
    rename_implementation! :governance_activities, :governance_records
    rename_implementation! :user_contribution_pathways, :contribution_pathways
  end

  def rename_implementation!(old_value, new_value)
    rename_enum_value :implementation_name, old_value, new_value

    TABLES.each do |table|
      change_table table do |t|
        t.rename :"#{old_value}_implementation", :"#{new_value}_implementation"
        t.rename old_value, new_value
      end
    end
  end

  def rename_enum(old_name, new_name)
    quoted_old_name = PG::Connection.quote_ident(old_name.to_s)
    quoted_new_name = PG::Connection.quote_ident(new_name.to_s)

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.strip)
        ALTER TYPE #{quoted_old_name} RENAME TO #{quoted_new_name};
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        ALTER TYPE #{quoted_new_name} RENAME TO #{quoted_old_name};
        SQL
      end
    end
  end

  def rename_enum_value(enum, old_value, new_value)
    quoted_enum = PG::Connection.quote_ident(enum.to_s)
    quoted_old_value = connection.quote(old_value)
    quoted_new_value = connection.quote(new_value)

    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc.strip
        ALTER TYPE #{quoted_enum} RENAME VALUE #{quoted_old_value} TO #{quoted_new_value};
        SQL
      end

      dir.down do
        execute <<~SQL.strip_heredoc.strip
        ALTER TYPE #{quoted_enum} RENAME VALUE #{quoted_new_value} TO #{quoted_old_value};
        SQL
      end
    end
  end
end
