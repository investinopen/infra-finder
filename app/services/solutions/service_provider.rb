# frozen_string_literal: true

module Solutions
  class ServiceProvider
    include Support::EnhancedStoreModel

    attribute :name, :string
    attribute :description, :string
    attribute :url, :string

    strip_attributes

    validates :url, presence: true, url: true
  end
end
