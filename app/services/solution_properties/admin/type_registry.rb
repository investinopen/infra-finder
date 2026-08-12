# frozen_string_literal: true

module SolutionProperties
  module Admin
    # The type registry used by {SolutionProperties::Admin} (and {AdminTab}).
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :property_wrapper, SolutionProperties::Admin::PropertyWrapper::Type
      tc.add! :property_wrappers, SolutionProperties::Admin::PropertyWrapper::List

      tc.add! :tab_wrapper, SolutionProperties::Admin::TabWrapper::Type
    end
  end
end
