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

    # graphql-ruby prices a connection by its `first`/`last` arguments, falling back to the
    # maximum page size. Page-based connections take `perPage` instead, so without this every
    # nested connection costs 200 times its nodes. This mirrors graphql-ruby's calculation.
    #
    # @see Resolvers::Enhancements::PageNumberExtension
    # @return [Integer]
    def calculate_complexity(query:, nodes:, child_complexity:)
      return super unless connection? && arguments.key?("perPage")

      args = query.arguments_for(nodes.first, self)

      return super unless args.respond_to?(:[])

      metadata_complexity = metadata_complexity_for(GraphQL::Execution::Lookahead.new(query:, field: self, ast_nodes: nodes, owner_type: owner))

      apply_own_complexity_to((page_size_for(args, query) * (child_complexity - metadata_complexity)) + metadata_complexity, query, nodes)
    end

    private

    # @return [Integer] the page size a page-based connection will return
    def page_size_for(args, query)
      return args[:per_page] if args[:per_page]

      return Support::GraphQLAPI::Constants::DEFAULT_PER_PAGE_SIZE if args[:page]

      max_page_size || query.schema.default_max_page_size
    end

    # The connection's own fields (`pageInfo` and the like), which are not repeated per node.
    #
    # @param [GraphQL::Execution::Lookahead] lookahead
    # @return [Integer]
    def metadata_complexity_for(lookahead)
      lookahead.selections.sum do |selection|
        selection.field.complexity + (selection.name.in?(%i[nodes edges]) ? 0 : selection.selections.size)
      end
    end
  end
end
