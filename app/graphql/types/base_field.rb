# frozen_string_literal: true

module Types
  # @abstract The base field type used throughout the schema.
  class BaseField < GraphQL::Schema::Field
    prepend ActionPolicy::GraphQL::AuthorizedField

    argument_class Types::BaseArgument

    # @param [Boolean] terms_exempt whether a root field stays available to
    #   viewers who have not yet accepted the terms and conditions
    # @see Analyzers::TermsGate
    def initialize(*args, terms_exempt: false, **kwargs, &block)
      @terms_exempt = terms_exempt

      super(*args, **kwargs, &block)
    end

    # @see Analyzers::TermsGate
    # @return [Boolean]
    def terms_exempt? = @terms_exempt
  end
end
