# frozen_string_literal: true

# A simple object that creates a {User} and automatically assigns it
# as an {ProviderEditorAssignment editor} for a {Provider}.
#
# @see InvitationTransition
class Invitation < ApplicationRecord
  include TimestampScopes
  include UsesStatesman

  has_state_machine!

  clear_exposed_ransackable_attributes!

  ransackable_minimum_allowance! :editor

  expose_ransackable_associations! :provider, on: :editor

  expose_ransackable_attributes! :provider_id, :email, :first_name, :last_name, on: :editor

  strip_attributes only: %i[email first_name last_name memo]

  belongs_to :provider, inverse_of: :invitations
  belongs_to :admin, optional: true, inverse_of: :created_invitations, class_name: "User"
  belongs_to :user, optional: true, inverse_of: :invitation

  validates :email, :first_name, :last_name, presence: true
  validates :email, email: { mode: :rfc }, uniqueness: true
  validates :user_id, uniqueness: { allow_blank: true }

  validate :user_must_be_persisted!, on: :finalize

  delegate :persisted?, to: :user, allow_nil: true, prefix: true

  after_create :finalize_on_create!

  # @api private
  # @see Invitations::CreateAssociatedUser
  # @see Invitations::UserCreator
  # @return [Dry::Monads::Success(Invitation)]
  monadic_operation! def create_associated_user
    call_operation("invitations.create_associated_user", self)
  end

  # @api private
  # @see Invitations::Finalize
  # @see Invitations::Finalizer
  # @return [Dry::Monads::Success(Invitation)]
  monadic_matcher! def finalize
    call_operation("invitations.finalize", self)
  end

  # @see Invitations::Notifier
  # @see Invitations::Notify
  # @return [Dry::Monads::Success(Invitation)]
  monadic_operation! def notify
    call_operation("invitations.notify", self)
  end

  # @!attribute [r] name
  # @return [String]
  def name
    [first_name, last_name].join(" ")
  end

  def to_user_attributes
    { email:, name:, }
  end

  private

  # @see #finalize
  # @note `after_create` hook
  # @return [void]
  def finalize_on_create!
    finalize do |m|
      m.success do
        # Intentionally left blank
      end

      m.failure :email_already_registered do
        errors.add :email, :already_registered
      end

      m.failure :user_creation_failed do |_, reason|
        # :nocov:
        errors.add(:base, :user_creation_failed, reason:)
        # :nocov:
      end

      m.failure :must_be_pending do
        errors.add :base, :must_be_pending
      end

      m.failure do
        # :nocov:
        errors.add :base, :something_went_wrong
        # :nocov:
      end
    end

    raise ActiveRecord::Rollback if errors.any?
  end

  # @return [void]
  def user_must_be_persisted!
    errors.add :user, :must_be_persisted unless user.try(:persisted?)
  end
end
