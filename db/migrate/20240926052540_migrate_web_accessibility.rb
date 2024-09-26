# frozen_string_literal: true

class MigrateWebAccessibility < ActiveRecord::Migration[7.1]
  PAIRINGS = [
    %i[solutions solution_id solution_accessibility_scopes],
    %i[solution_drafts solution_draft_id solution_draft_accessibility_scopes],
  ].freeze

  def up
    seed_accessibility_scopes!

    PAIRINGS.each do |(source_table, source_id, link_table)|
      migrate_links_from! source_table, source_id, link_table
    end
  end

  def down
    # Intentionally left blank
    # This is just a data port
  end

  private

  def migrate_links_from!(source_table, source_id, link_table)
    say_with_time "Migrating accessibility scopes for #{source_table} into #{link_table}" do
      exec_update(<<~SQL)
      WITH new_links AS (
        SELECT DISTINCT
          source.id AS #{source_id},
          ascope.id AS accessibility_scope_id,
          false as single,
          'web_accessibility_applicabilities' AS assoc
        FROM #{source_table} AS source
        INNER JOIN accessibility_scopes ascope ON ascope.provides IS NOT NULL AND source.web_accessibility @> jsonb_build_object(ascope.provides, true)
      )
      INSERT INTO #{link_table} (#{source_id}, accessibility_scope_id, single, assoc)
      SELECT #{source_id}, accessibility_scope_id, single, assoc FROM new_links
      ON CONFLICT DO NOTHING;
      SQL
    end
  end

  def seed_accessibility_scopes!
    say_with_time "ensuring accessibility scopes are populated" do
      exec_update(<<~SQL.strip_heredoc)
      INSERT INTO accessibility_scopes (name, slug, term, provides, visibility)
      VALUES
        ('Our website', 'our-website', 'Our website', 'applies_to_website', 'visible'),
        ('Our tool or project', 'our-tool-or-project', 'Our tool or project', 'applies_to_solution', 'visible')
      ON CONFLICT (slug) DO UPDATE SET
        name = EXCLUDED.name,
        term = EXCLUDED.term,
        provides = EXCLUDED.provides,
        visibility = EXCLUDED.visibility
      ;
      SQL
    end
  end
end
