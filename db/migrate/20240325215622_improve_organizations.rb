# frozen_string_literal: true

class ImproveOrganizations < ActiveRecord::Migration[7.1]
  def change
    change_table :organizations do |t|
      t.bigint :solutions_count, null: false, default: 0
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating organizations.solutions_count" do
          exec_update <<~SQL
          WITH sc AS (
            SELECT organization_id, count(*) AS solutions_count
            FROM solutions
            GROUP BY 1
          )
          UPDATE organizations SET solutions_count = sc.solutions_count
          FROM sc WHERE sc.organization_id = organizations.id;
          SQL
        end
      end
    end
  end
end
