# frozen_string_literal: true

module SolutionProperties
  module HasFreeInputs
    extend ActiveSupport::Concern

    included do
      attribute :free_inputs, SolutionProperties::FreeInputs.to_type
    end

    SolutionProperty.each_free_input do |prop|
      delegate *prop.free_input_accessors, to: :free_inputs
    end
  end
end
