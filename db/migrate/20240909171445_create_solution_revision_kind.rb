# frozen_string_literal: true

class CreateSolutionRevisionKind < ActiveRecord::Migration[7.1]
  LANG = "SQL"

  def change
    create_enum :solution_revision_kind, %w[initial direct draft import other]
    create_enum :solution_data_version, %w[v2 unknown]
    create_enum :solution_revision_provider_state, %w[same initial diff]

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION public.parse_solution_revision_kind(text) RETURNS public.solution_revision_kind AS $$
        SELECT
        CASE $1
        WHEN 'direct' THEN 'direct'::public.solution_revision_kind
        WHEN 'draft' THEN 'draft'::public.solution_revision_kind
        WHEN 'initial' THEN 'initial'::public.solution_revision_kind
        WHEN 'import' THEN 'import'::public.solution_revision_kind
        ELSE
          'other'::public.solution_revision_kind
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL

        execute <<~SQL
        CREATE FUNCTION public.parse_solution_data_version(text) RETURNS public.solution_data_version AS $$
        SELECT
        CASE $1
        WHEN 'v2' THEN 'v2'::public.solution_data_version
        ELSE
          'unknown'::public.solution_data_version
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION public.parse_solution_data_version(text);
        DROP FUNCTION public.parse_solution_revision_kind(text);
        SQL
      end
    end
  end
end
