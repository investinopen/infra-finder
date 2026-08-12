# frozen_string_literal: true

module Emails
  # A `Mail::Interceptor` that intercepts all outgoing emails and possibly
  # redirects or disables them.
  class Intercept
    include InfraFinder::Deps[
      allow_emails: "emails.allow",
    ]

    # @param [Mail::Message] mail The email to be delivered.
    # @return [void]
    def delivering_email(mail)
      mail.perform_deliveries = allow_delivery?(mail)
    end

    private

    def allow_delivery?(mail)
      allow_emails.(mail.to).success?
    end
  end
end
