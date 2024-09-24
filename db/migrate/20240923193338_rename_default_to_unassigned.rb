# frozen_string_literal: true

class RenameDefaultToUnassigned < ActiveRecord::Migration[7.1]
  def change
    rename_enum_value :user_kind, :default, :unassigned
  end

  private

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
