# frozen_string_literal: true

module Events
  module FetchesRecipients
    extend ActiveSupport::Concern
    extend DefinesMonadicOperation

    include Events::Named
    include Events::DerivesData

    include Support::CallsCommonOperation

    included do
      extend Dry::Core::ClassAttributes

      defines :recipients_options, type: Events::RecipientsOptions::Type

      recipients_options Events::RecipientsOptions.new.freeze

      recipients :fetch_event_recipients!
    end

    # @return [Dry::Monads::Success<Notifiable>]
    monadic_operation! def fetch_event_recipients
      derive_data!

      opts = {
        **params.to_h,
        record:,
        provider:,
        solution:,
        solution_draft:,
        solution_intake:,
        options: recipients_options,
        user:,
      }

      call_operation("events.fetch_recipients", **opts)
    end

    # @return [Events::RecipientsOptions]
    def recipients_options = self.class.recipients_options

    module ClassMethods
      # Set up the associated {Events::RecipientsOptions} for the notifier.
      #
      # @param [{ Symbol => Boolean }] new_options
      # @return [void]
      def fetches_recipients!(**new_options)
        new_opts = recipients_options.merge(**new_options)

        recipients_options new_opts.freeze
      end
    end
  end
end
