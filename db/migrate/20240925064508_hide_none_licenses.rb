# frozen_string_literal: true

class HideNoneLicenses < ActiveRecord::Migration[7.1]
  def up
    say_with_time "Hiding any licenses that provide 'none'" do
      exec_update <<~SQL
      UPDATE licenses SET visibility = 'hidden' WHERE provides = 'none';
      SQL
    end
  end

  def down
    # Intentionally left blank
  end
end
