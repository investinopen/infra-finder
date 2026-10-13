# frozen_string_literal: true

module Support
  module Constants
    # A pattern that matches any valid UUID string.
    ANY_UUID = /\A[0-9A-F]{8}-[0-9A-F]{4}-(?<version>[1-8])[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}\z/i

    EMAIL_PATTERN = URI::MailTo::EMAIL_REGEXP

    # A pattern matches any hexadecimal representation.
    HEXADECIMAL = /\A[0-9a-fA-F]+\z/

    # A pattern that matches a hexadecimal representation prefixed with `0x`.
    PREFIXED_HEXADECIMAL = /\A0x(?<hex>[0-9a-fA-F]+)\z/

    SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

    URL_PATTERN = URI::DEFAULT_PARSER.make_regexp(%w[http https]).freeze
  end
end
