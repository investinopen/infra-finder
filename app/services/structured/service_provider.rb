# frozen_string_literal: true

module Structured
  # Used by the following properties:
  # - `service_providers`
  class ServiceProvider < Structured::Model
    attribute :name, :string
    attribute :description, :string
    attribute :url, :string

    validates :url, presence: true, url: { allow_blank: true }
  end
end
