# frozen_string_literal: true

module Structured
  # Used by the following properties:
  # - `recent_grants`
  class Grant < Structured::Model
    attribute :name, :string
    attribute :starts_on, :date
    attribute :ends_on, :date

    attribute :display_date, :string

    attribute :funder, :string
    attribute :amount, :string

    attribute :grant_activities, :string

    attribute :award_announcement_url, :string

    attribute :notes, :string

    validates :award_announcement_url, url: { allow_blank: true }
  end
end
