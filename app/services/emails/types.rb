# frozen_string_literal: true

module Emails
  # Types related to {Emails}s and their associated models.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Address = Instance(::Mail::Address)

    Addresses = Array.of(Address)

    Domain = String.constrained(filled: true)

    Domains = Array.of(Domain)

    Emails = Array.of(Email)

    PotentialEmail = String.constrained(filled: true)

    PotentialEmails = Coercible::Array

    EmailInput = PotentialEmail | Address

    EmailInputs = Array.of(EmailInput)
  end
end
