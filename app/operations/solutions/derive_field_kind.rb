# frozen_string_literal: true

module Solutions
  class DeriveFieldKind
    extend Dry::Core::Cache

    include Dry::Monads[:maybe, :result, :do]

    # @param [#to_sym] field
    # @return [Dry::Monads::Success(SolutionProperties::Types::Kind)]
    # @return [Dry::Monads::Failure(:unknown_field, Symbol)]
    def call(field)
      raw_kind = yield raw_kind_for(field.to_sym)

      kind = yield SolutionProperties::Types::Kind.try(raw_kind).to_monad

      Success kind
    end

    private

    def free_input?(field)
      field.to_s.in?(SolutionProperties::FreeInputs.attribute_names)
    end

    # @param [Symbol] field
    # @return [Dry::Monads::Success(Solutions::Types::FieldKind)]
    # @return [Dry::Monads::Failure(:unknown_field, Symbol)]
    def raw_kind_for(field)
      return Success(:string) if free_input?(field)

      by_prop(field).or do
        maybe_implementation(field)
      end
    end

    def by_prop(field)
      prop = SolutionProperty.find field.to_s

      Success prop.kind
    rescue FrozenRecord::RecordNotFound
      Failure[:unknown_field, field]
    end

    def maybe_implementation(field)
      Implementation.find field.to_s

      Success :implementation
    rescue FrozenRecord::RecordNotFound
      Failure[:unknown_field, field]
    end
  end
end
