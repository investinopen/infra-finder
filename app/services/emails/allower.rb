# frozen_string_literal: true

module Emails
  # @see Emails::Allow
  class Allower < Support::HookBased::Actor
    include Support::CallsCommonOperation
    include Dry::Initializer[undefined: false].define -> do
      param :emails, Types::PotentialEmails

      option :allowed_domains, Types::Domains, default: proc { Array(EmailConfig.allowed_domains) }

      option :enabled, Types::Bool, default: proc { EmailConfig.enabled }
    end

    standard_execution!

    # @return [<Mail::Address>]
    attr_reader :addresses

    # @return [Dry::Monads::Success<Mail::Address>] if all email addresses are allowed.
    # @return [Dry::Monads::Failure(:email_disabled)] if email sending is disabled.
    # @return [Dry::Monads::Failure(:invalid_emails, <String>)] if any of the email addresses are invalid.
    # @return [Dry::Monads::Failure(:disallowed_domains, <Mail::Address>)] if any of the email addresses are not allowed
    def call
      run_callbacks :execute do
        yield prepare!

        yield check!

        yield check_allowed_domains!
      end

      Success addresses
    end

    wrapped_hook! def prepare
      @addresses = yield call_operation("emails.parse", emails)

      super
    end

    wrapped_hook! def check
      yield check_enabled!

      yield check_allowed_domains!

      super
    end

    private

    # @return [void]
    def check_allowed_domains!
      return Success() if allowed_domains.blank?

      invalid = addresses.reject do |address|
        address.domain.in?(allowed_domains)
      end

      if invalid.any?
        Failure[:disallowed_domains, invalid]
      else
        Success()
      end
    end

    def check_enabled!
      if enabled
        Success()
      else
        Failure(:email_disabled)
      end
    end
  end
end
