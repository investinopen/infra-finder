# frozen_string_literal: true

class AddItemStateToComparisons < ActiveRecord::Migration[7.1]
  def change
    create_enum :comparison_item_state, %w[empty single many maxed_out]

    change_table :comparisons do |t|
      t.bigint :comparison_items_count, null: false, default: 0
      t.enum :item_state, enum_type: :comparison_item_state, null: false, default: :empty
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        WITH item_states AS (
          SELECT
            comparison_id,
            COUNT(*) AS comparison_items_count,
            CASE
            WHEN COUNT(*) >= 4 THEN 'maxed_out'::comparison_item_state
            WHEN COUNT(*) > 1 THEN 'many'::comparison_item_state
            ELSE
              'single'::comparison_item_state
            END AS item_state
            FROM comparison_items
            GROUP BY 1
        ) UPDATE comparisons SET comparison_items_count = item_states.comparison_items_count, item_state = item_states.item_state
        FROM item_states WHERE item_states.comparison_id = comparisons.id
        ;
        SQL
      end
    end
  end
end
