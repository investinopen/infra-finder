# frozen_string_literal: true

module HasName
  extend ActiveSupport::Concern

  included do
    strip_attributes only: :name

    scope :by_name, ->(name) { where(name:) }

    validates :name, presence: true
  end
end
