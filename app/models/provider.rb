# frozen_string_literal: true

# An organizational model for a {Solution}.
class Provider < ApplicationRecord
  include BuildsSelectOptions
  include Commentable
  include Filterable
  include HasSystemTags
  include SluggedByName
  include SolutionImportable
  include TimestampScopes

  has_normalized_name!

  expose_ransackable_associations! :solutions

  expose_ransackable_attributes! :solutions_count, :url

  scope :in_default_order, -> { in_alphabetical_order }

  scope :with_editor_access_for, ->(user) { where(id: ProviderEditorAssignment.where(user:).select(:provider_id)) }
  scope :with_multiple_solutions, -> { where(arel_table[:solutions_count].gt(1)) }

  has_many :invitations, dependent: :destroy, inverse_of: :provider
  has_many :provider_editor_assignments, inverse_of: :provider, dependent: :destroy
  has_many :solutions, inverse_of: :provider, dependent: :restrict_with_error
  has_many :solution_intakes, inverse_of: :provider, dependent: :nullify
  has_many :solution_revisions, inverse_of: :provider, dependent: :nullify

  # Declared after provider_editor_assignments so that their roles still exist
  # when the assignments are destroyed, which lets the editors' kind be recalculated.
  resourcify

  validates :name, presence: true, length: { maximum: 200 }

  validates :url, url: { allow_blank: true }

  # @see User.assignable_to
  # @return [ActiveRecord::Relation<User>]
  def assignable_users
    User.assignable_to(self)
  end

  # @param [User] user
  # @return [ProviderEditorAssignment]
  def assign_editor!(user)
    provider_editor_assignments.where(user:).first_or_create!
  end

  class << self
    # @param [String] name
    # @return [String, nil]
    def identifier_by_name(name)
      where(name:).pick(:identifier)
    end
  end
end
