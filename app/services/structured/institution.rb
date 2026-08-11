# frozen_string_literal: true

module Structured
  # Used by the following properties:
  # - `current_affiliations`
  # - `founding_institutions`
  # - `top_granting_institutions`
  class Institution < Structured::Model
    attribute :name, :string
    attribute :description, :string
    attribute :url, :string

    validates :name, presence: true
    validates :url, url: { allow_blank: true }
  end
end
