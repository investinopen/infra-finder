# frozen_string_literal: true

module Solutions
  class DeriveFieldKind
    extend Dry::Core::Cache

    include Dry::Monads[:maybe, :result, :do]

    # @param [#to_sym] field
    # @return [Dry::Monads::Success(Solutions::Types::FieldKind)]
    # @return [Dry::Monads::Failure(:unknown_field, Symbol)]
    def call(field)
      raw_kind = yield raw_kind_for(field.to_sym)

      kind = yield Solutions::Types::FieldKind.try(raw_kind).to_monad

      Success kind
    end

    private

    # @return [<Symbol>]
    def enum_columns
      fetch_or_store(__method__) do
        Solution.columns.select(&:enum?).map(&:name).map(&:to_sym).sort
      end
    end

    # @param [Symbol] field
    # @return [Dry::Monads::Success(Solutions::Types::FieldKind)]
    # @return [Dry::Monads::Failure(:unknown_field, Symbol)]
    def raw_kind_for(field)
      case field
      when *SolutionInterface::ATTACHMENTS
        :attachment
      when *SolutionInterface::BLURBS
        :blurb
      when *SolutionInterface::IMPLEMENTATIONS
        :implementation
      when *SolutionInterface::MULTIPLE_OPTIONS
        :multi_option
      when *SolutionInterface::SINGLE_OPTIONS
        :single_option
      when *SolutionInterface::TAG_LISTS
        :tag_list
      when *SolutionInterface::STORE_MODEL_LISTS
        :store_model_list
      when *enum_columns
        :enum
      else
        # :nocov:
        :standard if field.in?(SolutionInterface::TO_CLONE)
        # :nocov:
      end.then { Maybe(_1) }.or do
        Failure[:unknown_field, field]
      end
    end
  end
end
