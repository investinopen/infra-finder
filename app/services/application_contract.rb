# frozen_string_literal: true

# @abstract
class ApplicationContract < Dry::Validation::Contract
  config.types = Shared::TypeRegistry

  import_predicates_as_macros

  register_macro :slug_format do
    key.failure(:must_be_slug) unless Support::GlobalTypes::SLUG_PATTERN.match? value
  end

  register_macro :email_format do
    key.failure(:must_be_email) unless Support::GlobalTypes::EMAIL_PATTERN.match? value
  end

  register_macro :maybe_email_format do
    key.failure(:must_be_email) unless value.blank? || Support::GlobalTypes::EMAIL_PATTERN.match?(value)
  end

  register_macro :maybe_url_format do
    key.failure(:must_be_url) unless value.blank? || Support::GlobalTypes::URL_PATTERN.match?(value)
  end

  register_macro :url_format do
    key.failure(:must_be_url) unless Support::GlobalTypes::URL_PATTERN.match?(value)
  end
end
