# frozen_string_literal: true

module Analyzers
  # Mirrors `ApplicationController#enforce_acceptance_of_terms!` for the GraphQL API.
  #
  # A viewer who has not accepted the terms and conditions may only select root
  # fields declared with `terms_exempt: true`, such as `viewer` and
  # `viewerAcceptTerms`. It runs once per operation, before execution.
  class TermsGate < GraphQL::Analysis::Analyzer
    # @return [Boolean]
    def analyze?
      user = query.context[:current_user]

      user.kind_of?(::User) && user.has_unaccepted_terms?
    end

    # @param [GraphQL::Language::Nodes::Field] _node
    # @param [GraphQL::Language::Nodes::AbstractNode] _parent
    # @param [GraphQL::Analysis::Visitor] visitor
    # @return [void]
    def on_enter_field(_node, _parent, visitor)
      return unless root?(visitor.parent_type_definition)

      field = visitor.field_definition

      return if field.nil? || field.introspection? || field.try(:terms_exempt?)

      @blocked = true
    end

    # @return [GraphQL::AnalysisError, nil]
    def result
      return unless @blocked

      GraphQL::AnalysisError.new(
        I18n.t("server_messages.auth.terms_not_accepted"),
        extensions: { code: "TERMS_NOT_ACCEPTED" }
      )
    end

    private

    # @param [Class] type
    # @return [Boolean]
    def root?(type)
      type == query.schema.query || type == query.schema.mutation
    end
  end
end
