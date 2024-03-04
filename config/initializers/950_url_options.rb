# frozen_string_literal: true

Rails.application.configure do |app|
  app.config.action_mailer.default_url_options = LocationsConfig.root_url_options
end
