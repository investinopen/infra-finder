# frozen_string_literal: true

# An organizational model for a {Solution}.
class Organization < ApplicationRecord
  include Filterable
  include HasSystemTags
  include SluggedByName
  include SolutionImportable

  expose_ransackable_associations! :solutions

  expose_ransackable_attributes! :url

  has_many :solutions, inverse_of: :organization, dependent: :restrict_with_error

  validates :name, presence: true

  validates :url, url: { allow_blank: true }
end
