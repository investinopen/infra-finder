# frozen_string_literal: true

module SolutionProperties
  module HasCountryCode
    extend ActiveSupport::Concern

    # @!attribute [r] country_name
    # @return [String]
    def country_name
      ISO3166::Country[country_code].try(:iso_short_name)
    end

    alias location_of_incorporation country_name
  end
end
