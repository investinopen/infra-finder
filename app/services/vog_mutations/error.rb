# frozen_string_literal: true

module VOGMutations
  # Represents an error that occurred during a mutation operation.
  #
  # It is exposed in GraphQL responses either via:
  # * `attributeErrors` via {::Types::MutationAttributeErrorType}
  # * `globalErrors` via {::Types::MutationGlobalErrorType}
  #
  # Each error includes a message, an optional code, and path information.
  # @api private
  class Error < Support::FlexibleStruct
    attribute :message, ::Support::GlobalTypes::String
    attribute :code, ::Support::GlobalTypes::Coercible::String.optional
    attribute :path, ::Support::DryMutations::Types::AttributePath
    attribute :attribute_path, ::Support::GlobalTypes::String
    attribute? :global, ::Support::GlobalTypes::Bool.default(false)

    alias global? global

    # The default type for errors if a code was not provided
    SERVER = "$server"

    # @return [String]
    attr_reader :scope

    # @return [String]
    attr_reader :type

    def initialize(...)
      super

      @scope = global? ? "global" : "attribute"
      @type = code.presence || SERVER
    end

    # @!attribute [r] attribute_error_key
    # @return [(String, String)]
    def attribute_error_key = [attribute_path, type]

    # @return [Hash{Symbol => String}]
    def to_global_error
      {
        message:,
        type:,
      }
    end
  end
end
