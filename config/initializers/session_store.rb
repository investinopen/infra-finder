# frozen_string_literal: true

Rails.application.config.session_store(:active_record_store, **SessionConfig.to_session_store_options)

Rails.application.config.to_prepare do
  ActionDispatch::Session::ActiveRecordStore.session_class = ::SessionRecord
end
