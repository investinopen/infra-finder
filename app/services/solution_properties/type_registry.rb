# frozen_string_literal: true

module SolutionProperties
  # The type registry used by {SolutionProperty}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :assign_method, SolutionProperties::Types::AssignMethod
    tc.add! :connection_mode, ControlledVocabularies::Types::ConnectionMode
    tc.add! :implementation_name, Implementations::Types::Name
    tc.add! :implementation_property, Implementations::Types::Property
    tc.add! :input, SolutionProperties::Types::Input
    tc.add! :kind, SolutionProperties::Types::Kind
    tc.add! :only, SolutionProperties::Types::SolutionKind.optional
    tc.add! :phase_2_status, SolutionProperties::Types::Phase2Status
    tc.add! :visibility, SolutionProperties::Types::Visibility
    tc.add! :vocab_name, ControlledVocabularies::Types::VocabName
  end
end
