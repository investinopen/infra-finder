# frozen_string_literal: true

# A concern for a model that has a (likely unique) name, that identifies it,
# and can be used for filtering, sorting, etc.
module HasName
  extend ActiveSupport::Concern

  include ExposesRansackable
  include Filterable

  included do
    extend Dry::Core::ClassAttributes

    strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

    scope :in_alphabetical_order, -> { lazily_order(:name) }

    scope :by_name, ->(name) { where(name:) }

    validates :name, presence: true

    defines :has_normalized_name, type: Support::Types::Bool

    has_normalized_name false

    filter_collection_order_scope :in_alphabetical_order

    expose_ransackable_attributes! :name

    ransacker :name, formatter: -> { I18n.transliterate(_1).downcase } do
      name_order_column
    end
  end

  module ClassMethods
    def has_normalized_name?
      has_normalized_name.present?
    end

    # @return [void]
    def has_normalized_name!
      has_normalized_name true
    end

    def name_order_column
      if has_normalized_name?
        arel_table[:normalized_name]
      else
        arel_named_fn("normalize_ransackable", arel_table[:name])
      end
    end
  end
end
