# frozen_string_literal: true

ActiveSnapshot.config do |config|
  config.storage_method = "native_json"
end

Rails.application.configure do
  config.to_prepare do
    ActiveSnapshot::Snapshot.include TimestampScopes
    ActiveSnapshot::SnapshotItem.include TimestampScopes
  end
end
