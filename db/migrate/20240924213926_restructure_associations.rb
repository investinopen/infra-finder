# frozen_string_literal: true

class RestructureAssociations < ActiveRecord::Migration[7.1]
  class PluralityMigration < Support::FlexibleStruct
    ConnectionMode = Support::Types::Symbol.enum(:multiple, :single)

    MULTIPLE_QUERY = <<~SQL.strip_heredoc.strip
    INSERT INTO %<link_table_name>s (%<source_id>s, %<target_id>s, assoc, single, created_at, updated_at)
    SELECT %<source_id>s, %<target_id>s, %<inverse_assoc>s AS assoc, %<inverse_single>s AS single, created_at, updated_at
    FROM %<link_table_name>s
    WHERE assoc = %<assoc>s AND single = %<single>s
    ORDER BY %<source_id>s, created_at DESC
    ON CONFLICT (%<source_id>s, %<target_id>s, assoc) WHERE NOT single DO NOTHING
    SQL

    SINGLE_QUERY = <<~SQL.strip_heredoc.strip
    INSERT INTO %<link_table_name>s (%<source_id>s, %<target_id>s, assoc, single, created_at, updated_at)
    SELECT DISTINCT ON (%<source_id>s) %<source_id>s, %<target_id>s, %<inverse_assoc>s AS assoc, %<inverse_single>s AS single, created_at, updated_at
    FROM %<link_table_name>s
    WHERE assoc = %<assoc>s AND single = %<single>s
    ORDER BY %<source_id>s, created_at ASC
    ON CONFLICT (%<source_id>s, assoc) WHERE single DO UPDATE SET
      %<target_id>s = EXCLUDED.%<target_id>s,
      created_at = EXCLUDED.created_at,
      updated_at = EXCLUDED.updated_at
    SQL

    module Invertable
      extend ActiveSupport::Concern

      def label(inverted: false)
        inverted ? down_label : up_label
      end

      def options_for(inverted: false)
        base = inverted ? to_inverted : self

        base.to_options
      end

      def quote(value)
        ApplicationRecord.connection.quote value
      end

      def to_inverted
        self.class.new(from: to, to: from)
      end

      def to_options; end

      private

      def up_label
        "from %<from>s to %<to>s" % { from:, to:, }
      end

      def down_label
        "from %<to>s to %<from>s" % { from:, to:, }
      end
    end

    class TableRef < Support::FlexibleStruct
      attribute :id, Support::Types::Coercible::String
      attribute :table_name, Support::Types::Coercible::String
    end

    attribute :assoc, Support::FlexibleStruct do
      include Invertable

      attribute :from, Support::Types::String
      attribute :to, Support::Types::String

      def to_options
        {
          assoc: quote(from),
          inverse_assoc: quote(to),
        }
      end
    end

    attribute :indices, Support::FlexibleStruct do
      attribute :multiple, Support::Types::Coercible::String
      attribute :single, Support::Types::Coercible::String
    end

    attribute :mode, Support::FlexibleStruct do
      include Invertable

      attribute :from, ConnectionMode
      attribute :to, ConnectionMode

      def up
        { connection_mode: to, inverted: false }
      end

      def down
        { connection_mode: from, inverted: true }
      end
    end

    attribute :single, Support::FlexibleStruct do
      include Invertable

      attribute :from, Support::Types::Bool
      attribute :to, Support::Types::Bool

      def to_options
        { single: quote(from), inverse_single: quote(to) }
      end
    end

    attribute :link_table_name, Support::Types::Coercible::String

    attribute :source, TableRef
    attribute :target, TableRef

    delegate :id, :table_name, to: :source, prefix: true
    delegate :id, :table_name, to: :target, prefix: true

    def label(inverted: false)
      "Migrating existing #{link_table_name} (mode: #{mode.label(inverted:)}) (assoc #{assoc.label(inverted:)})"
    end

    def up_query
      build_query_for(**mode.up)
    end

    def down_query
      build_query_for(**mode.down)
    end

    private

    def build_query_for(connection_mode:, inverted: false)
      options = build_query_options_for(inverted:)

      case connection_mode
      in :multiple
        MULTIPLE_QUERY % options
      in :single
        SINGLE_QUERY % options
      end
    end

    def build_query_options_for(inverted: false)
      {
        **assoc.options_for(inverted:),
        **single.options_for(inverted:),
        link_table_name:,
        source_id:,
        target_id:,
      }
    end
  end

  MIGRATIONS = YAML.load(<<~YAML).map { PluralityMigration.new(_1) }.freeze
  ---
  - :assoc:
      :from: maintenance_statuses
      :to: maintenance_status
    :mode:
      :from: :multiple
      :to: :single
    :single:
      :from: false
      :to: true
    :indices:
      :multiple: udx_solution_maintenance_statuses_multi
      :single: udx_solution_maintenance_statuses_single
    :link_table_name: solution_maintenance_statuses
    :source:
      :id: solution_id
      :table_name: solutions
    :target:
      :id: maintenance_status_id
      :table_name: maintenance_statuses
  - :assoc:
      :from: maintenance_statuses
      :to: maintenance_status
    :mode:
      :from: :multiple
      :to: :single
    :single:
      :from: false
      :to: true
    :indices:
      :multiple: udx_solution_draft_maintenance_statuses_multi
      :single: udx_solution_draft_maintenance_statuses_single
    :link_table_name: solution_draft_maintenance_statuses
    :source:
      :id: solution_draft_id
      :table_name: solution_drafts
    :target:
      :id: maintenance_status_id
      :table_name: maintenance_statuses
  - :assoc:
      :from: readiness_levels
      :to: readiness_level
    :mode:
      :from: :multiple
      :to: :single
    :single:
      :from: false
      :to: true
    :indices:
      :multiple: udx_solution_readiness_levels_multi
      :single: udx_solution_readiness_levels_single
    :link_table_name: solution_readiness_levels
    :source:
      :id: solution_id
      :table_name: solutions
    :target:
      :id: readiness_level_id
      :table_name: readiness_levels
  - :assoc:
      :from: readiness_levels
      :to: readiness_level
    :mode:
      :from: :multiple
      :to: :single
    :single:
      :from: false
      :to: true
    :indices:
      :multiple: udx_solution_draft_readiness_levels_multi
      :single: udx_solution_draft_readiness_levels_single
    :link_table_name: solution_draft_readiness_levels
    :source:
      :id: solution_draft_id
      :table_name: solution_drafts
    :target:
      :id: readiness_level_id
      :table_name: readiness_levels
  YAML

  def change
    reversible do |dir|
      dir.up do
        say_with_time "Purging solution revisions" do
          exec_delete <<~SQL.strip
          DELETE FROM solution_revisions;
          SQL
        end

        say_with_time "Purging snapshots" do
          exec_delete <<~SQL.strip
          DELETE FROM snapshots;
          SQL
        end
      end
    end

    MIGRATIONS.each do |migration|
      perform_plurality! migration
    end
  end

  def perform_plurality!(migration)
    reversible do |dir|
      dir.up do
        say_with_time migration.label(inverted: false) do
          exec_update migration.up_query
        end
      end

      dir.down do
        say_with_time migration.label(inverted: true) do
          exec_update migration.down_query
        end
      end
    end
  end
end
