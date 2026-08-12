# frozen_string_literal: true

class AdminTab < Support::FrozenRecordHelpers::AbstractRecord
  include Support::Typing

  type_registry SolutionProperties::Admin::TypeRegistry

  schema! do
    required(:name).filled(:string)

    required(:property_names).array(:string) { filled? }

    required(:property_wrappers).value(:property_wrappers)

    required(:tab_wrapper).value(:tab_wrapper)
  end

  calculates! :property_wrappers do |record|
    record["property_names"].flat_map do |property_name|
      property = SolutionProperty.lookup_coded_ext(property_name)

      SolutionProperties::Admin::PropertyWrapper.normalize(property)
    end
  end

  calculates! :tab_wrapper do |record|
    SolutionProperties::Admin::TabWrapper.new record["name"], record["property_wrappers"]
  end

  self.primary_key = :name

  add_index :name, unique: true

  class << self
    # @return [<SolutionProperties::Admin::TabWrapper>]
    def wrapped_tabs = pluck(:tab_wrapper)
  end
end
