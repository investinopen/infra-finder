# frozen_string_literal: true

# The entry point for the GraphQL schema.
#
# @see GraphqlController#execute
# @subsystem GraphQL
class APISchema < GraphQL::Schema
  # simplecov:disable
  if SystemConfig.use_async_dataloader?
    use Support::GraphQLAPI::AsynchronousDataloader
  else
    use Support::GraphQLAPI::SynchronousDataloader
  end
  # simplecov:enable

  validate_timeout nil

  use GraphQL::FragmentCache

  mutation Types::MutationType

  query Types::QueryType

  default_max_page_size Support::GraphQLAPI::Constants::MAX_PER_PAGE_SIZE

  max_depth Support::GraphQLAPI::Constants::MAX_DEPTH

  max_complexity Support::GraphQLAPI::Constants::MAX_COMPLEXITY

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    # simplecov:disable
    type_name = field.try(:type).try(:unwrap).try(:graphql_name) || "Unknown type"

    GraphQL::ExecutionError.new(
      "#{type_name} raised an error: ActiveRecord:RecordNotFound - #{err.message}",
      extensions: {
        code: "NOT_FOUND",
        type_name:,
      }
    )
    # simplecov:enable
  end

  rescue_from(ActionPolicy::Unauthorized) do |_|
    GraphQL::ExecutionError.new(
      I18n.t("server_messages.auth.forbidden"),
      extensions: {
        code: "FORBIDDEN"
      }
    )
  end

  extra_types(
    Types::FilterMatchDateType,
    Types::FilterMatchFloatType,
    Types::FilterMatchIntegerType,
    Types::FilterMatchTimeType,
    Types::FilterMatchDateInputType,
    Types::FilterMatchFloatInputType,
    Types::FilterMatchIntegerInputType,
    Types::FilterMatchTimeInputType,
  )

  orphan_types(
    Types::FilterMatchDateType,
    Types::FilterMatchFloatType,
    Types::FilterMatchIntegerType,
    Types::FilterMatchTimeType,
  )

  class << self
    # @param [Object] object
    # @param [GraphQL::Schema::ObjectType] type_definition
    # @param [GraphQL::Query::Context] query_context
    # @return [String]
    def id_from_object(object, type_definition, query_context)
      Support::System["relay_node.id_from_object"].call(object, type_definition:, query_context:) do |m|
        m.success do |id|
          id
        end

        m.failure do
          # simplecov:disable
          raise GraphQL::ExecutionError.new("Cannot derive ID")
          # simplecov:enable
        end
      end
    end

    # @param [String] id
    # @param [GraphQL::Query::Context] query_context
    # @return [Object]
    def object_from_id(id, query_context)
      Support::System["relay_node.object_from_id"].call(id, query_context:) do |m|
        m.success do |object|
          object
        end

        m.failure do
          # simplecov:disable
          raise GraphQL::ExecutionError.new("Cannot find model for ID: #{id.inspect}")
          # simplecov:enable
        end
      end
    end

    # @param [GraphQL::Schema::Object] abstract_type
    # @param [Object] object
    # @param [GraphQL::Query::Context] context
    # @return [Class(GraphQL::Schema::Object)]
    # @return [GraphQL::ExecutionError] when unable to resolve type
    def resolve_type(abstract_type, object, context)
      # Remap arg order because we really mainly care about object
      Support::System["relay_node.resolve_type"].call(object, abstract_type, context).value_or do |reason|
        # simplecov:disable
        opts = {
          extensions: { abstract_type: abstract_type&.graphql_name }
        }

        case reason
        when GraphQL::ExecutionError then reason
        when String then GraphQL::ExecutionError.new(reason, **opts)
        else
          raise GraphQL::ExecutionError.new("Unexpected object: #{object.inspect}", **opts)
        end
        # simplecov:enable
      end
    end
  end
end
