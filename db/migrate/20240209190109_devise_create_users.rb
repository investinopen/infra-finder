# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.citext  :email,              null: false, default: ""
      t.text    :encrypted_password, null: false, default: ""

      t.text :name, null: false

      t.boolean :super_admin, null: false, default: false

      ## Recoverable
      t.text   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.bigint    :sign_in_count, default: 0, null: false
      t.datetime  :current_sign_in_at
      t.datetime  :last_sign_in_at
      t.inet      :current_sign_in_ip
      t.inet      :last_sign_in_ip

      ## Confirmable
      t.text      :confirmation_token
      t.datetime  :confirmed_at
      t.datetime  :confirmation_sent_at
      t.citext    :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.bigint    :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.text      :unlock_token # Only if unlock strategy is :email or :both
      t.datetime  :locked_at

      t.timestamps null: false

      t.index :email, unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token, unique: true
      t.index :unlock_token, unique: true
    end
  end
end
