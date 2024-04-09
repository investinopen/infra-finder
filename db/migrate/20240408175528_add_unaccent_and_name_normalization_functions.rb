# frozen_string_literal: true

class AddUnaccentAndNameNormalizationFunctions < ActiveRecord::Migration[7.1]
  LANG = "SQL"

  TABLES_TO_NORMALIZE = %w[
    organizations
    solutions
    solution_drafts
  ].freeze

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE OR REPLACE FUNCTION public.immutable_unaccent(regdictionary, text)
          RETURNS text
          LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE STRICT
          RETURN public.unaccent($1, $2)
        ;

        CREATE OR REPLACE FUNCTION public.f_unaccent(text)
          RETURNS text
          LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE STRICT
          RETURN public.immutable_unaccent(regdictionary 'public.unaccent', $1)
        ;

        CREATE OR REPLACE FUNCTION public.normalize_ransackable(text)
          RETURNS citext
          LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE STRICT
          RETURN CAST(LOWER(public.f_unaccent($1)) AS citext);

        CREATE OR REPLACE FUNCTION public.normalize_ransackable(citext)
          RETURNS citext
          LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE STRICT
          RETURN CAST(LOWER(public.f_unaccent($1::text)) AS citext);
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION public.normalize_ransackable(citext);
        DROP FUNCTION public.normalize_ransackable(text);
        DROP FUNCTION public.f_unaccent(text);
        DROP FUNCTION public.immutable_unaccent(regdictionary, text);
        SQL
      end
    end

    TABLES_TO_NORMALIZE.each do |tbl|
      change_table tbl do |t|
        t.virtual :normalized_name, type: :citext, null: false, as: %[normalize_ransackable(name)], stored: true

        t.index :normalized_name
      end
    end
  end
end
