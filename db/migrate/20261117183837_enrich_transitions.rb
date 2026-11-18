# frozen_string_literal: true

class EnrichTransitions < ActiveRecord::Migration[8.1]
  def change
    create_enum :user_state, %w[pending accepted_terms]

    enrich_transitions! :user, default_state: :pending

    create_enum :solution_draft_state, %w[pending in_review approved rejected]

    enrich_transitions! :solution_draft, default_state: :pending

    create_enum :invitation_state, %w[pending created success failure]

    enrich_transitions! :invitation, default_state: :pending

    create_enum :subscription_state, %w[unsubscribed subscribed]

    enrich_transitions! :subscription, default_state: :unsubscribed

    create_enum :solution_import_state, %w[pending invalid started success failure]

    enrich_transitions! :solution_import, default_state: :pending

    migrate_solution_intakes_to_match!
  end

  private

  def enrich_transitions!(prefix, default_state:, **options)
    config = MigrationConfig.new(prefix, default_state:, **options)

    add_missing_user_reference!(prefix, config)

    enforce_to_state_for!(prefix, config)

    backfill_from_state_for!(prefix, config)

    backfill_initial_transitions_for!(prefix, config)

    add_missing_cached_state!(prefix, config)
  end

  # @return [void]
  def migrate_solution_intakes_to_match!
    change_table :solution_intake_transitions do |t|
      t.references :initiator, null: true, type: :uuid, polymorphic: true
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        UPDATE solution_intake_transitions
        SET initiator_id = user_id,
            initiator_type = 'User'
        WHERE user_id IS NOT NULL;
        SQL
      end
    end
  end

  def add_missing_cached_state!(prefix, config)
    change_table config.base_table do |t|
      t.enum :state, enum_type: config.enum_type, default: config.default_state, null: false
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        WITH most_recent_transitions AS (
          SELECT DISTINCT ON (#{config.foreign_key})
            #{config.foreign_key},
            to_state
          FROM #{config.transitions_table}
          WHERE most_recent AND to_state <> #{connection.quote(config.default_state)}
        )
        UPDATE #{config.base_table} b
        SET state = m.to_state
        FROM most_recent_transitions m
        WHERE b.id = m.#{config.foreign_key};
        SQL
      end
    end
  end

  def add_missing_user_reference!(prefix, config)
    change_table config.transitions_table do |t|
      t.references :initiator, null: true, type: :uuid, polymorphic: true
    end
  end

  def enforce_to_state_for!(prefix, config)
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE #{config.transitions_table}
        ALTER COLUMN to_state SET DATA TYPE #{config.enum_type} USING to_state::#{config.enum_type};
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE #{config.transitions_table}
        ALTER COLUMN to_state SET DATA TYPE text USING to_state::text;
        SQL
      end
    end
  end

  def backfill_initial_transitions_for!(prefix, config)
    reversible do |dir|
      dir.up do
        exec_update <<~SQL

        WITH existing_initial_transitions AS (
          SELECT DISTINCT ON (#{config.foreign_key})
            #{config.foreign_key},
            to_state
          FROM #{config.transitions_table}
          WHERE
            to_state = #{connection.quote(config.default_state)}
            AND
            sort_key = 10
        ), oldest_transition AS (
          SELECT DISTINCT ON (#{config.foreign_key})
            #{config.foreign_key},
            to_state,
            sort_key
          FROM #{config.transitions_table}
          ORDER BY #{config.foreign_key}, sort_key ASC
        ), new_transitions AS (
          SELECT
            b.id AS #{config.foreign_key},
            NULL::#{config.enum_type} AS from_state,
            #{connection.quote(config.default_state)}::#{config.enum_type} AS to_state,
            COALESCE(ot.sort_key - 10, 10) AS sort_key,
            CASE WHEN ot.to_state IS NULL THEN true ELSE false END AS most_recent,
            b.created_at AS created_at,
            b.updated_at AS updated_at
          FROM #{config.base_table} b
          LEFT JOIN oldest_transition ot ON b.id = ot.#{config.foreign_key}
          WHERE b.id NOT IN (SELECT #{config.foreign_key} FROM existing_initial_transitions)
        )
        INSERT INTO #{config.transitions_table} (#{config.foreign_key}, from_state, to_state, sort_key, most_recent, created_at, updated_at)
        SELECT #{config.foreign_key}, from_state, to_state, sort_key, most_recent, created_at, updated_at
        FROM new_transitions;
        SQL
      end
    end
  end

  def backfill_from_state_for!(prefix, config)
    change_table config.transitions_table do |t|
      t.enum :from_state, enum_type: config.enum_type, null: true
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        WITH derived_from_states AS (
          SELECT
            id,
            COALESCE(
              lag(to_state, 1) OVER w,
              CASE WHEN sort_key = 10 AND to_state <> #{connection.quote(config.default_state)}::#{config.enum_type} THEN #{connection.quote(config.default_state)}::#{config.enum_type} END
            ) AS from_state
          FROM #{config.transitions_table}
          WINDOW w AS (
            PARTITION BY #{config.foreign_key}
            ORDER BY sort_key DESC
          )
        )
        UPDATE #{config.transitions_table} t
        SET from_state = d.from_state
        FROM derived_from_states d
        WHERE t.id = d.id;
        SQL
      end
    end
  end

  class MigrationConfig
    include Dry::Initializer[undefined: false].define -> do
      param :prefix, Support::Types::Symbol

      option :default_state, Support::Types::Symbol

      option :enum_type, Support::Types::Symbol, default: proc { :"#{prefix}_state" }

      option :base_table, Support::Types::Symbol, default: proc { prefix.to_s.tableize.to_sym }

      option :foreign_key, Support::Types::Symbol, default: proc { :"#{prefix}_id" }

      option :transitions_table, Support::Types::Symbol, default: proc { :"#{prefix}_transitions" }
    end
  end
end
