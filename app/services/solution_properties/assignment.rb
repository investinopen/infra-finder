# frozen_string_literal: true

module SolutionProperties
  class Assignment < Support::FlexibleStruct
    attribute :accessor, ::SolutionProperties::Accessors::AbstractAccessor::Type
    attribute :property, ::SolutionProperty::Type
    attribute :attribute_name, Types::AttributeName
    attribute :value, Types::Any.optional

    attribute? :csv_header, Types::CSVHeader
    attribute? :csv_row, Types::CSVRow

    # @return [SolutionProperties::Types::AssignmentKind]
    attr_reader :kind

    def initialize(...)
      super

      @kind = derive_assignment_kind
    end

    # @param [Solution, SolutionDraft] instance
    # @return [void]
    def assign!(instance)
      accessor.apply_assignment! instance, self
    end

    def attachment? = kind == :attachment

    def standard? = kind == :standard

    private

    def derive_assignment_kind
      case property.kind
      in :attachment
        :attachment
      else
        :standard
      end
    end
  end
end
