# frozen_string_literal: true

module Structured
  # A registry represents an external public registered URL that
  # can be used to identify information about the solution.
  #
  # Examples:
  # - https://fairsharing.org/FAIRsharing.j0t0pe
  # - https://www.re3data.org/repository/r3d100010931
  #
  # A URL _must_ be provided, other attributes are optional.
  #
  # Used by the following properties:
  # - `registries`
  class Registry < Structured::Model
    attribute :name, :string
    attribute :description, :string
    attribute :url, :string

    validates :url, presence: true, url: { allow_blank: false }
  end
end
