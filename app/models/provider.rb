# frozen_string_literal: true

# An organizational model for a {Solution}.
class Provider < ApplicationRecord
  include BuildsSelectOptions
  include Filterable
  include HasSystemTags
  include SluggedByName
  include SolutionImportable

  has_normalized_name!

  expose_ransackable_associations! :solutions

  expose_ransackable_attributes! :solutions_count, :url

  scope :with_multiple_solutions, -> { where(arel_table[:solutions_count].gt(1)) }

  has_many :solutions, inverse_of: :provider, dependent: :restrict_with_error

  validates :name, presence: true

  validates :url, url: { allow_blank: true }
end
