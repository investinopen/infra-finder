# frozen_string_literal: true

module SolutionProperties
  # Define and expose implementation enums and store models for {SolutionInterface}.
  module HasImplementations
    extend ActiveSupport::Concern

    included do
      Implementation.each do |implementation|
        pg_enum! implementation.enum, as: implementation.enum_type.to_sym, default: :unknown, prefix: implementation.name

        attribute implementation.name, implementation.type.to_type, default: proc { {} }

        delegate :available_with_url?, :has_url?, to: implementation.name, prefix: implementation.name

        validates implementation.name, store_model: true
      end
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
