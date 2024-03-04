# frozen_string_literal: true

unless Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :smtp

  Rails.application.config.action_mailer.smtp_settings = EmailConfig.smtp_settings
end
