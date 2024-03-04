# frozen_string_literal: true

# A role that can be assigned to a {User}, possibly for a given record.
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify
end
