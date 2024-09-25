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

      scope :maintenance_active, -> { maintenance_status_provides("active") }
      scope :maintenance_inactive, -> { maintenance_status_provides("inactive") }
      scope :maintenance_unknown, -> { maintenance_status_provides("unknown") }
    end
  end
end
