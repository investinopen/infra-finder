# frozen_string_literal: true

module Solutions
  class ComparableProduct
    include Support::EnhancedStoreModel

    attribute :name, :string
    attribute :description, :string
    attribute :url, :string

    strip_attributes

    validates :name, presence: true
    validates :url, url: { allow_blank: true }
  end
end
