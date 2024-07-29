# frozen_string_literal: true

module SolutionProperties
  module HasControlledVocabularyConnections
    extend ActiveSupport::Concern

    include ControlledVocabularies::ConnectionIntrospections
    include SolutionProperties::HasSolutionKind

    included do
      ControlledVocabularyConnection.for_kind(solution_kind).each do |connection|
        connection.apply_to! self
      end

      scope :maintenance_active, -> { maintenance_statuses_provides("active") }
      scope :maintenance_inactive, -> { maintenance_statuses_provides("inactive") }
      scope :maintenance_unknown, -> { maintenance_statuses_provides("unknown") }
    end

    def maintenance_active?
      maintenance_statuses.exists?(provides: "active")
    end
  end
end
