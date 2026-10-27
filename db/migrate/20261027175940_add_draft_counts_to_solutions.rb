# frozen_string_literal: true

class AddDraftCountsToSolutions < ActiveRecord::Migration[8.1]
  def change
    change_table :solutions, bulk: true do |t|
      t.bigint :all_drafts_count, null: false, default: 0
      t.bigint :pending_and_in_review_drafts_count, null: false, default: 0
    end

    reversible do |dir|
      dir.up do
        say_with_time "Counting drafts" do
          exec_update(<<~SQL)
          UPDATE solutions
          SET all_drafts_count = counts.all_count, pending_and_in_review_drafts_count = counts.open_count
          FROM (
            SELECT d.solution_id,
              COUNT(*) AS all_count,
              COUNT(*) FILTER (WHERE COALESCE(t.to_state, 'pending') IN ('pending', 'in_review')) AS open_count
            FROM solution_drafts d
            LEFT OUTER JOIN solution_draft_transitions t ON t.solution_draft_id = d.id AND t.most_recent
            WHERE d.solution_id IS NOT NULL
            GROUP BY d.solution_id
          ) AS counts
          WHERE solutions.id = counts.solution_id
          SQL
        end
      end
    end
  end
end
