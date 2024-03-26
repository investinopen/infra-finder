# frozen_string_literal: true

# A concern for a model that has a (likely unique) name, that identifies it,
# and can be used for filtering, sorting, etc.
module HasName
  extend ActiveSupport::Concern

  include ExposesRansackable
  include Filterable

  included do
    strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

    scope :in_alphabetical_order, -> { lazily_order(:name) }

    scope :by_name, ->(name) { where(name:) }

    validates :name, presence: true

    filter_collection_order_scope :in_alphabetical_order

    expose_ransackable_attributes! :name
  end
end
