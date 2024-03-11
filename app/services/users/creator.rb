# frozen_string_literal: true

module Users
  class Creator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :email, Types::Email
      param :name, Types::String.constrained(filled: true)

      option :password, Types::String.constrained(filled: true), default: proc { Devise.friendly_token }
      option :super_admin, Types::Bool, default: proc { false }
      option :admin, Types::Bool, default: proc { false }

      option :skip_confirmation, Types::Bool, default: proc { false }
    end

    include MonadicPersistence

    standard_execution!

    # @return [User]
    attr_reader :user

    delegate :skip_confirmation!, to: :user

    def call
      run_callbacks :execute do
        yield build!

        yield persist!
      end

      Success user
    end

    wrapped_hook! def build
      @user = User.new(email:, name:, password:, password_confirmation: password, super_admin:, admin:)

      super
    end

    wrapped_hook! def persist
      yield monadic_save user

      super
    end

    after_build :skip_confirmation!, if: :skip_confirmation
  end
end
