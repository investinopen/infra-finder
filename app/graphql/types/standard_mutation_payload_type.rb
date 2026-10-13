# frozen_string_literal: true

module Types
  # An interface for standardizing mutation payloads that follow {VOGMutations} paradigms.
  #
  # @see VOGMutations::Response
  module StandardMutationPayloadType
    include Types::BaseInterface

    description <<~TEXT
    A baseline interface for all mutations in order to offer a standard shape for handling errors.
    TEXT

    field :attribute_errors, [Types::MutationAttributeErrorType, { null: false }], null: false do
      description <<~TEXT
      A list of attribute-specific errors that occurred during the mutation.
      TEXT
    end

    field :global_errors, [Types::MutationGlobalErrorType, { null: false }], null: false do
      description <<~TEXT
      A list of global errors that occurred during the mutation.
      TEXT
    end

    field :halt_code, String, null: true, deprecation_reason: "Not presently used." do
      description <<~TEXT
      Not presently used.
      TEXT
    end

    # @see VOGMutations::ErrorCompiler
    # @return [Array<Hash{Symbol => Object}>]
    def attribute_errors
      object[:attribute_errors].map do |(path, type), messages|
        { path:, type:, messages: }
      end
    end
  end
end
