# frozen_string_literal: true

class CreateSessionsEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions_events, id: :uuid do |t|
      t.string :event, null: false # login / failed_login / logout / revoked / expired

      # Polymorphic and NULLABLE: failed attempts against unknown identities
      # have no account to point at — the typed `identity` column below is
      # what correlates them.
      t.references :authenticatable, polymorphic: true, type: :uuid, index: false
      t.string :scope

      # The trail ↔ registry linkage. A plain column, NO foreign key:
      # lifecycle rows are normally ended in place, but account-erasure and
      # legacy host deletes may still remove them. A suspicious login here
      # is one lookup away from revoking the live session it created.
      t.uuid :session_id

      t.string :identity # email-as-typed (normalized), even for unknown accounts
      # The browser-continuity id (same value as the registry row's) — lets
      # `Sessions.last_login(request)` answer "how did this browser last
      # sign in" after logout, powering the "Last used" login-page badge.
      t.string :device_id, limit: 36
      t.string :auth_method
      t.string :auth_provider
      t.jsonb :auth_detail
      t.string :failure_reason # devise message symbol / omniauth error type, verbatim
      t.string :revoked_reason # user_revoked / admin_revoked / password_change /
      #                          logout_everywhere / pruned / unknown

      t.inet :ip_address
      t.text :user_agent
      t.jsonb :client_hints
      t.string :browser_name
      t.string :browser_version
      t.string :os_name
      t.string :os_version
      t.string :device_type
      t.string :device_model
      t.string :app_name
      t.string :app_version
      t.string :app_build

      # Geo via trackdown (soft dependency). lat/lng precision-reduced per
      # config.geo_precision (2 decimals ≈ 1km) — privacy now,
      # impossible-travel math later.
      t.string :country_code, limit: 2
      t.string :country_name
      t.string :city
      t.string :region
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7

      t.string :request_id
      t.string :context # "controller#action"
      t.jsonb :metadata

      t.datetime :occurred_at, null: false
    end

    add_index :sessions_events, %i[authenticatable_type authenticatable_id occurred_at],
              name: "index_sessions_events_on_authenticatable_and_occurred_at"
    add_index :sessions_events, %i[event occurred_at]
    add_index :sessions_events, %i[device_id occurred_at]
    add_index :sessions_events, :identity
    add_index :sessions_events, :ip_address
    add_index :sessions_events, :session_id
    add_index :sessions_events, :occurred_at
  end
end
