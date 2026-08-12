# frozen_string_literal: true

# A `Noticed::Notification` extension that adds additional functionality.
module NoticedNotificationExtension
  extend ActiveSupport::Concern

  include NoticedCommonExtension

  included do
    attribute :email_contact, Emails::EmailContact.to_type
  end
end
