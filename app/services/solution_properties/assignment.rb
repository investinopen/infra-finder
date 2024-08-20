# frozen_string_literal: true

module SolutionProperties
  class Assignment < Support::FlexibleStruct
    attribute :accessor, Types.Instance(::SolutionProperties::Accessors::AbstractAccessor)
    attribute :property, Types.Instance(::SolutionProperty)
    attribute :attribute_name, Types::Coercible::Symbol
    attribute :value, Types::Any.optional

    attribute? :csv_header, Types::Coercible::String
    attribute? :csv_row, Types.Instance(::CSV::Row)

    # @param [Solution, SolutionDraft] instance
    # @return [void]
    def assign!(instance)
      accessor.apply_assignment! instance, self
    end

    def attachment?
      property.kind == :attachment
    end

    def standard?
      !attachment?
    end

    private

    # @param [Solution, SolutionDraft] instance
    # @return [void]
    def assign_attachment_to!(instance)
      return if value.blank?

      attacher = instance.__send__(:"#{attribute_name}_attacher")

      attacher.remote_url = value

      attacher.add_metadata "original_import_url" => value
    end

    # @param [Solution, SolutionDraft] instance
    # @return [void]
    def assign_standard_to!(instance)
      instance.public_send(:"#{attribute_name}=", value)
    end
  end
end
