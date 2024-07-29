# frozen_string_literal: true

module SolutionProperties
  module Admin
    module TrackForm
      extend ActiveSupport::Concern

      included do
        around_action :track_property_access!, only: %i[new edit]
      end

      # @return [void]
      def track_property_access!
        # :nocov:
        return yield unless Rails.env.local?

        expected = SolutionProperty.should_be_in_admin_form.pluck(:name)

        expected.concat(Implementation.pluck(:name))

        RequestStore.fetch(:property_form_access) do
          Hash.new { |h, k| h[k] = 0 }.with_indifferent_access
        end

        yield

        rendered = RequestStore[:property_form_access].keys

        unaccounted = expected - rendered

        raise "Did not render input for expected prop(s): #{unaccounted.inspect}" if unaccounted.any?
        # :nocov:
      end
    end
  end
end
