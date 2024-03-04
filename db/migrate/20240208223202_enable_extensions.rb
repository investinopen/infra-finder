# frozen_string_literal: true

class EnableExtensions < ActiveRecord::Migration[7.1]
  def change
    enable_extension "citext"
    enable_extension "intarray"
    enable_extension "ltree"
    enable_extension "pgcrypto"
    enable_extension "plpgsql"
    enable_extension "unaccent"
    enable_extension "btree_gist"
    enable_extension "fuzzystrmatch"
    enable_extension "pg_trgm"
  end
end
