# frozen_string_literal: true

module Implementations
  class Link
    include Support::EnhancedStoreModel

    attribute :label, :string
    attribute :url, :string

    strip_attributes

    validates :url, url: { allow_blank: true }, presence: { if: :parent_requires_populated_link? }

    delegate :requires_populated_link?, to: :parent, prefix: true, allow_nil: true
  end
end
