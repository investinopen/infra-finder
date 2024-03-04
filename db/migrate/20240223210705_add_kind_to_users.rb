# frozen_string_literal: true

class AddKindToUsers < ActiveRecord::Migration[7.1]
  def change
    create_enum :user_kind, %i[super_admin admin editor default anonymous]

    change_table :users do |t|
      t.boolean :admin, null: false, default: false

      t.enum :kind, enum_type: :user_kind, default: :default, null: false

      t.index :kind
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting default kind for super admins" do
          exec_update <<~SQL
          UPDATE users SET kind = 'super_admin' WHERE super_admin;
          SQL
        end
      end
    end
  end
end
