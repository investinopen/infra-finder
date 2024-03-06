# frozen_string_literal: true

module Solutions
  class Grant
    include Support::EnhancedStoreModel

    attribute :name, :string
    attribute :starts_on, :date
    attribute :ends_on, :date

    attribute :display_date, :string

    attribute :funder, :string
    attribute :amount, :string

    attribute :grant_activities, :string

    attribute :award_announcement_url, :string

    attribute :notes, :string

    strip_attributes

    validates :award_announcement_url, url: { allow_blank: true }
  end
end
