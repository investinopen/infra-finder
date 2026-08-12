# frozen_string_literal: true

module Invitations
  # @see Invitations::Attempt
  class Attempter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :provider, Types::Provider

      option :email, Types::String

      option :first_name, Types::String

      option :last_name, Types::String

      option :memo, Types::String.optional, optional: true
    end

    standard_execution!

    # @return [Invitation, nil]
    attr_reader :invitation

    # @return [Dry::Monads::Success(Invitation)]
    # @return [Dry::Monads::Success(nil)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield attempt!
      end

      Success invitation
    end

    wrapped_hook! def prepare
      @invitation = nil

      super
    end

    wrapped_hook! def attempt
      @invitation = Invitation.new(provider:, email:, first_name:, last_name:, memo:)

      unless @invitation.save
        @invitation = nil
      end

      super
    end

    private

    # @return [void]
    def within_transaction!
      ActiveRecord::Base.transaction(requires_new: true) do
        yield
      end
    end
  end
end
