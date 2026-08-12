# frozen_string_literal: true

module Events
  # Types related to `Noticed::Event`s and their associated models.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    # A type matching a valid event name string.
    # Event names must be dot-separated lowercase words, e.g. "foo.bar.baz".
    # @return [Dry::Types::Type(String)]
    EventName = Coercible::String.constrained(filled: true, format: /\A[a-z_]+(\.[a-z_]+)*\z/)

    ParamsHash = Hash.map(Coercible::Symbol, Types::Any).default(Dry::Core::Constants::EMPTY_HASH).fallback(Dry::Core::Constants::EMPTY_HASH)

    # A type matching a {::Provider} instance.
    # @return [Dry::Types::Type(::Provider)]
    Provider = ModelInstance("Provider")

    # A type matching a {::Solution} instance.
    # @return [Dry::Types::Type(::Solution)]
    Solution = ModelInstance("Solution")

    # A type matching a {::SolutionDraft} instance.
    # @return [Dry::Types::Type(::SolutionDraft)]
    SolutionDraft = ModelInstance("SolutionDraft")

    # A type matching a {::SolutionIntake} instance.
    # @return [Dry::Types::Type(::SolutionIntake)]
    SolutionIntake = ModelInstance("SolutionIntake")

    # A type matching a {::User} instance.
    # @return [Dry::Types::Type(::User)]
    User = ModelInstance("User")
  end
end
