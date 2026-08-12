# frozen_string_literal: true

# A notifiable record represents a potential recipient for a `Noticed::Notification`.
module Notifiable
  extend ActiveSupport::Concern
  extend Support::Typing

  included do
    has_many :notifications, as: :recipient, inverse_of: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
  end

  def email_deliverable? = to_email_contact.deliverable?

  def notifiable? = email_deliverable?

  # @return [Hash] the contact information to generate a {Emails::EmailContact}.
  def notifiable_attrs
    name = notifiable_contact_name
    email = notifiable_contact_email

    {
      name:,
      email:,
    }
  end

  # @api private
  # @abstract
  # @return [String] the name for the notifiable record
  def notifiable_contact_name = name

  # @api private
  # @abstract
  # @return [String] the email address for the notifiable record
  def notifiable_contact_email = email

  # @return [Emails::EmailContact]
  def to_email_contact = Emails::EmailContact.from(self)

  # @return [Mail::Address]
  def to_mail_address = to_email_contact.to_addr
end
