# frozen_string_literal: true

unless Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :smtp

  Rails.application.config.action_mailer.smtp_settings = EmailConfig.smtp_settings

  Rails.application.config.action_mailer.deliver_later_queue_name = "mailers"
end

Premailer::Rails.config.merge!(
  generate_text_part: true,
  input_encoding: "UTF-8",
  preserve_styles: true,
  remove_ids: true
)
