# frozen_string_literal: true

class CreateDoorkeeperTables < ActiveRecord::Migration[8.1]
  def change
    create_table :oauth_applications, id: :uuid do |t|
      t.string :name, null: false
      t.string :uid, null: false
      t.string :secret
      t.text :redirect_uri, null: false
      t.text :post_logout_redirect_uri, null: false, default: ""
      t.string :scopes, null: false, default: ""
      t.boolean :confidential, null: false, default: true
      t.timestamps

      t.index :uid, unique: true
    end

    create_table :oauth_access_grants, id: :uuid do |t|
      t.references :resource_owner, type: :uuid, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :application, type: :uuid, null: false, foreign_key: { to_table: :oauth_applications, on_delete: :cascade }
      t.string :token, null: false
      t.integer :expires_in, null: false
      t.text :redirect_uri, null: false
      t.string :scopes, null: false, default: ""
      t.string :code_challenge
      t.string :code_challenge_method
      t.datetime :created_at, null: false
      t.datetime :revoked_at

      t.index :token, unique: true
    end

    create_table :oauth_access_tokens, id: :uuid do |t|
      t.references :resource_owner, type: :uuid, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :application, type: :uuid, null: false, foreign_key: { to_table: :oauth_applications, on_delete: :cascade }
      t.string :token, null: false
      t.string :refresh_token
      t.integer :expires_in
      t.string :scopes
      t.string :previous_refresh_token, null: false, default: ""
      t.uuid :session_id, null: false
      t.datetime :session_started_at, null: false
      t.datetime :created_at, null: false
      t.datetime :revoked_at

      t.index :token, unique: true
      t.index :refresh_token, unique: true
      t.index :session_id
      t.index :session_started_at
      t.index :revoked_at
    end

    create_table :oauth_openid_requests, id: :uuid do |t|
      t.references :access_grant, type: :uuid, null: false, foreign_key: { to_table: :oauth_access_grants, on_delete: :cascade }
      t.string :nonce, null: false
    end
  end
end
