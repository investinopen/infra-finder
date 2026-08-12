# frozen_string_literal: true

module Emails
  # A value object representing an email contact.
  class EmailContact
    include Support::EnhancedStoreModel

    attribute :address, :string
    attribute :name, :string

    alias_attribute :email, :address

    validates :address, email: true
    validates :address, presence: true

    def deliverable? = valid?

    def display_name = name.presence || address

    # @return [Mail::Address] the address as a Mail::Address object
    def to_addr = Mail::Address.new(to_s)

    def to_s = "#{name} <#{address}>"

    class << self
      # @param [Emails::EmailContact, Notifiable, String, nil] input
      # @return [Emails::EmailContact]
      def from(input)
        case input
        in ::Emails::EmailContact => email
          email
        in ::Notifiable => notifiable
          new(notifiable.notifiable_attrs)
        in ::String => address
          new(address:)
        in nil
          Emails::EmailContact.new
        end
      end
    end
  end
end
