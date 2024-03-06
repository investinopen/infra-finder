# frozen_string_literal: true

# An assignment of a {User} to a {Solution} that grants them
# a reduced degree of editorial privilege.
class SolutionEditorAssignment < ApplicationRecord
  belongs_to :solution, inverse_of: :solution_editor_assignments
  belongs_to :user, inverse_of: :solution_editor_assignments

  after_destroy :remove_role_assignment!

  after_save :enforce_role_assignment!

  delegate :name, to: :solution, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  validates :user_id, uniqueness: { scope: :solution_id }

  private

  # @return [void]
  def enforce_role_assignment!
    user.add_role :editor, solution
  end

  # @return [void]
  def remove_role_assignment!
    user.remove_role :editor, solution
  end

  class << self
    def ransackable_associations(auth_object = nil)
      [
        "solution",
        "user",
      ]
    end

    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "created_at",
        "updated_at",
        "solution_id",
        "user_id",
      ]
    end

    def ransackable_scopes(auth_object = nil)
      []
    end
  end
end
