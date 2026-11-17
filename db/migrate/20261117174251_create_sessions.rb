# frozen_string_literal: true

# The Rails-8-shaped sessions table for a Devise app: one row = one signed-in
# device lifecycle (`ended_at: nil` means live; history lives in
# sessions_events). Deliberately the SAME base shape
# `rails generate authentication` creates — so if you ever migrate from
# Devise to Rails auth, your sessions table is already waiting.
class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.inet :ip_address
      t.text :user_agent

      # Devise/Warden mode: SHA-256 of a random token whose raw value lives
      # ONLY in the user's own session (OWASP: never persist raw session
      # identifiers). The Warden adapter validates it on every request; only
      # a matching token plus explicit lifecycle end may sign that device out.
      t.string :token_digest

      # The Warden scope ("user") — multi-scope Devise apps.
      t.string :scope

      # Adopted sessions (pre-gem logins that had no sessions token yet)
      # get one deterministic owner+scope key. Normal sessions keep this
      # NULL, so the unique index below constrains only adopted rows while
      # staying portable across PostgreSQL, MySQL and SQLite.
      t.string :adoption_key

      # How this session started: password / oauth / google_one_tap /
      # passkey / magic_link / otp / sso / token / unknown — plus the
      # provider and per-method extras.
      t.string :auth_method
      t.string :auth_provider
      t.jsonb :auth_detail

      # Parsed device intelligence — projections of the raw user_agent
      # ("Chrome 137 on macOS", "MyApp 2.4.1 on Pixel 8 (Android 16)").
      t.string :browser_name
      t.string :browser_version
      t.string :os_name
      t.string :os_version
      t.string :device_type   # desktop / smartphone / tablet / native_ios / native_android / bot / unknown
      t.string :device_model  # "iPhone15,2", "Pixel 8" — when knowable
      t.string :app_name      # Hotwire Native apps
      t.string :app_version
      t.string :app_build
      t.jsonb :client_hints # raw Sec-CH-UA* + X-Client-* headers, for re-parsing

      # Approximate location via the trackdown gem (soft dependency).
      t.string :country_code, limit: 2
      t.string :country_name
      t.string :city
      t.string :region

      # Browser continuity: a random id minted at login into a signed,
      # long-lived cookie identifying the BROWSER INSTALL (never the user).
      # Lets a repeat login from the same browser supersede its old row
      # instead of stacking duplicate devices.
      t.string :device_id, limit: 36

      # The throttled activity touch (at most one write per config.touch_every).
      t.datetime :last_seen_at

      t.string :last_seen_ip, limit: 45

      # Lifecycle state. v0.2 keeps rows as the source of truth instead of
      # deleting them and asking events to act as tombstones. `ended_at: nil`
      # is the live-device set; explicit ended_reason values are the only
      # thing a Devise/Warden request is allowed to enforce.
      t.datetime :ended_at
      t.string :ended_reason
      # The explicit index below keeps the generated name consistent across
      # create-table and upgrade paths. `references` indexes by default, so
      # disable that implicit index to avoid two identical indexes.
      t.references :ended_by, polymorphic: true, type: :uuid, index: false
      t.jsonb :ended_metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    add_index :sessions, :device_id
    add_index :sessions, :token_digest, unique: true
    add_index :sessions, :adoption_key, unique: true
    add_index :sessions, :auth_method
    add_index :sessions, :auth_provider
    add_index :sessions, :country_code
    add_index :sessions, :last_seen_at
    add_index :sessions, :ended_at
    add_index :sessions, :ended_reason
    add_index :sessions, %i[ended_by_type ended_by_id]
  end
end
