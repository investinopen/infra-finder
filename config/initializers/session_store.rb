# frozen_string_literal: true

store_options = SessionConfig.to_session_store_options

Rails.application.config.session_store(:redis_store, **store_options)
