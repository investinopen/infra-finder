# frozen_string_literal: true

module SolutionProperties
  # Define and expose implementation enums and store models for {SolutionInterface}.
  module HasImplementations
    extend ActiveSupport::Concern

    included do
      Implementation.each do |implementation|
        pg_enum! implementation.enum, as: implementation.enum_type.to_sym, default: :unknown, prefix: implementation.name

        attribute implementation.name, implementation.type.to_type, default: proc { {} }

        validates implementation.name, store_model: true
      end

      # @deprecated
      pg_enum! :phase_1_maintenance_status, as: :maintenance_status, prefix: :phase_1_maintenance, allow_blank: false, default: :unknown

      delegate :applies?, :applies_to_solution?, :applies_to_website?,
        to: :web_accessibility, prefix: :web_accessibility_statement
    end

    Implementation.each do |impl|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{impl.name}_attributes=(impl_attributes)
        self[#{impl.name.inspect}] = impl_attributes
      end

      def #{impl.structured_attr}
        #{impl.name}.to_csv
      end

      def #{impl.structured_attr}=(json)
        return if json.blank?

        self[#{impl.name.inspect}] = JSON.parse(json)
      end
      RUBY
    end
  end
end
