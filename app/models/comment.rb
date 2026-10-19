# frozen_string_literal: true

# A comment left by an admin or editor on a {Commentable} record.
#
# @note This shares ActiveAdmin's `active_admin_comments` table, so that comments
#   made in ActiveAdmin and through the API are the same records.
class Comment < ApplicationRecord
  include TimestampScopes

  NAMESPACE = "admin"

  self.table_name = "active_admin_comments"

  attribute :namespace, :string, default: NAMESPACE

  belongs_to :author, polymorphic: true
  belongs_to :resource, polymorphic: true, inverse_of: :comments

  scope :in_default_order, -> { in_oldest_order }

  validates :body, presence: true
end
