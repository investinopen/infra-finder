# frozen_string_literal: true

ActiveSupport.on_load(:active_record) do
  ActiveRecord::SessionStore::Session.serializer = :json
end

Rails.application.config.session_store(:active_record_store, **SessionConfig.to_session_store_options)
