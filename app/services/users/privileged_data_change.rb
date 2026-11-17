# frozen_string_literal: true

module Users
  class PrivilegedDataChange
    include Support::Typing

    include Dry::Core::Equalizer.new(:user_id)

    include Dry::Initializer[undefined: false].define -> do
      param :user, Types::Current, default: proc { AnonymousUser.new }

      option :email, Types::String.optional, default: proc { user.email }

      option :password, Types::String.optional, optional: true

      option :current_password, Types::String.optional, optional: true
    end

    delegate :id, to: :user, prefix: true

    # @return [Boolean]
    attr_reader :authenticated

    alias authenticated? authenticated

    # @return [Boolean]
    attr_reader :password_valid

    alias password_valid? password_valid

    # @return [Boolean]
    attr_reader :email_changed

    alias email_changed? email_changed

    # @return [Boolean]
    attr_reader :password_changed

    alias password_changed? password_changed

    def initialize(...)
      super

      @email_changed = email.present? && user.email != email
      @password_changed = password.present?
      @authenticated = user.kind_of?(::User)
      @password_valid = authenticated? && user.valid_password?(current_password)
    end

    def allowed?
      if needs_authentication?
        return password_valid?
      end

      true
    end

    def needs_authentication? = authenticated? && (email_changed? || password_changed?)
  end
end
