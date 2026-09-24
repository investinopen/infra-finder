# frozen_string_literal: true

class AddClaimToSolutions < ActiveRecord::Migration[7.1]
  def change
    create_enum :solution_claim_state, %w[unclaimed claimed]

    create_view :solution_derived_claims

    change_table :solutions, bulk: true do |t|
      t.enum :claim_state, enum_type: :solution_claim_state, default: "unclaimed", null: false

      t.index :claim_state
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        UPDATE solutions s SET claim_state = 'claimed'
        FROM solution_derived_claims sdc
        WHERE sdc.solution_id = s.id AND sdc.claim_state = 'claimed';
        SQL
      end
    end
  end
end
