# frozen_string_literal: true

module Emails
  class Parse
    include Dry::Monads[:result, :do, :validated, :list]

    EMPTY = /\A\s*\z/

    # @overload call(emails)
    #   @param [<String, Mail::Address>] emails The email addresses to parse.
    #   @return [Dry::Monads::Success<Mail::Address>]
    #   @return [Dry::Monads::Failure(:invalid_emails, <String>)] if any of the email addresses are invalid.
    # @overload call(email)
    #   @param [String, Mail::Address] email The email address to parse.
    #   @return [Dry::Monads::Success(Mail::Address)]
    #   @return [Dry::Monads::Failure] if the email address is invalid.
    def call(input)
      case input
      in EMPTY | nil
        Failure(:empty_email)
      in Mail::Address => address
        Success(address)
      in Emails::Types::PotentialEmail => email
        parse(email)
      in Array => emails
        parse_list(emails)
      else
        Failure[:invalid_input, input]
      end
    end

    private

    # @param [<String>] emails
    # @return [Dry::Monads::Success<Mail::Address>]
    # @return [Dry::Monads::Failure(:invalid_emails, <String>)] if any of the email addresses are invalid.
    # @return [Dry::Monads::Failure(:empty_emails)] if emails.empty?
    def parse_list(emails)
      return Failure(:empty_emails) if emails.empty?

      validations = emails.map do |email|
        parse_and_validate(email)
      end

      validated = List::Validated.coerce(validations).traverse.to_result

      case validated
      in Success(Dry::Monads::List => addresses)
        Success(addresses.to_a)
      in Failure(Dry::Monads::List => errors)
        Failure[:invalid_emails, errors.to_a]
      else
        # simplecov:disable
        raise "Impossible validation result: #{validated.inspect}"
        # simplecov:enable
      end
    end

    # @return [Dry::Monads::Success(Mail::Address)] if the email address is valid.
    # @return [Dry::Monads::Failure(:invalid_email, String, String)] if the email address is invalid.
    # @return [Dry::Monads::Failure(:missing_domain, String)] if the email address is missing a domain.
    def parse(email)
      parsed = Mail::Address.new(email)
    rescue Mail::Field::ParseError => e
      Failure[:invalid_email, email, e.message]
    else
      if parsed.domain.blank?
        Failure[:missing_domain, email]
      else
        Success(parsed)
      end
    end

    # @param [String] email
    # @return [Dry::Monads::Validated]
    def parse_and_validate(email)
      call(email).to_validated.or { Invalid(email) }
    end
  end
end
