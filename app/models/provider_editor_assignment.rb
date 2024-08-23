# frozen_string_literal: true

# An assignment of a {User} to a {Provider} that grants them
# a reduced degree of editorial privilege over their {Solution} record(s).
class ProviderEditorAssignment < ApplicationRecord
  include TimestampScopes

  belongs_to :provider, inverse_of: :provider_editor_assignments
  belongs_to :user, inverse_of: :provider_editor_assignments

  has_many :solutions, through: :provider

  expose_ransackable_associations! :provider, :user, on: :admin
  expose_ransackable_attributes! :id, :created_at, :updated_at, :provider_id, :user_id, on: :admin

  after_destroy :remove_role_assignment!

  after_save :enforce_role_assignment!

  delegate :name, to: :provider, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  validates :user_id, uniqueness: { scope: :provider_id }

  private

  # @return [void]
  def enforce_role_assignment!
    user.add_role :editor, provider
  end

  # @return [void]
  def remove_role_assignment!
    user.remove_role :editor, provider
  end
end
