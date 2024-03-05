# frozen_string_literal: true

# An organizational model for a {Solution}.
class Organization < ApplicationRecord
  include Filterable
  include SluggedByName

  has_many :solutions, inverse_of: :organization, dependent: :restrict_with_error

  validates :name, presence: true

  validates :url, url: { allow_blank: true }

  class << self
    def ransackable_associations(auth_object = nil)
      [
        "solutions",
      ]
    end

    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "created_at",
        "updated_at",
        "name",
        "url"
      ]
    end
  end
end
