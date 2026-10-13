# frozen_string_literal: true

module Support
  module GraphQLAPI
    # An asynchronous dataloader for GraphQL queries.
    #
    # @see https://graphql-ruby.org/dataloader/dataloader
    class AsynchronousDataloader < GraphQL::Dataloader::AsyncDataloader
      self.default_fiber_limit = nil

      self.default_nonblocking = false

      # @return [Symbol] Fiber variable key for database connection info.
      DATABASE_CONNECTION_KEY = :connected_to

      # @return [Symbol] Fiber variable key tracking which databases had their query cache enabled.
      QUERY_CACHE_KEY = :query_cache_enabled

      ISOLATED_EXECUTION_CONTEXT = :active_support_execution_context

      # @return [Symbol] `IsolatedExecutionState` key for the local (in-memory) cache registry.
      #   Shared so that `Rails.cache`'s `LocalCache` strategy keeps deferring to the in-memory
      #   store within resolver fibers instead of re-fetching from the backing store (e.g. SolidCache).
      LOCAL_CACHE_REGISTRY = :active_support_local_cache_registry

      # @return [Hash] Fiber variables to set for the new fiber.
      def get_fiber_variables
        vars = super

        vars[DATABASE_CONNECTION_KEY] = {}
        vars[QUERY_CACHE_KEY] = {}

        databases.each do |key, klass|
          vars[DATABASE_CONNECTION_KEY][key] = connected_to_for(klass)
          vars[QUERY_CACHE_KEY][key] = klass.connection_pool.query_cache_enabled
        end

        vars[ISOLATED_EXECUTION_CONTEXT] = ActiveSupport::IsolatedExecutionState[ISOLATED_EXECUTION_CONTEXT]
        vars[LOCAL_CACHE_REGISTRY] = ActiveSupport::IsolatedExecutionState[LOCAL_CACHE_REGISTRY]

        vars
      end

      # @param [Hash] vars Fiber variables to set for the new fiber.
      # @return [void]
      def set_fiber_variables(vars)
        # Reset connection config from the parent fiber:

        connections = vars.delete(DATABASE_CONNECTION_KEY) || {}
        query_caches = vars.delete(QUERY_CACHE_KEY) || {}

        databases.each do |key, klass|
          klass.connecting_to(**connections[key])

          # Query cache state is keyed by `IsolatedExecutionState.context` (the fiber), so it must be
          # re-enabled per child fiber whenever it was enabled in the parent fiber.
          klass.connection_pool.enable_query_cache! if query_caches[key]
        end

        ActiveSupport::IsolatedExecutionState[ISOLATED_EXECUTION_CONTEXT] = vars.delete(ISOLATED_EXECUTION_CONTEXT)
        ActiveSupport::IsolatedExecutionState[LOCAL_CACHE_REGISTRY] = vars.delete(LOCAL_CACHE_REGISTRY)

        super
      end

      # @return [void]
      def cleanup_fiber
        super

        databases.values.each do |klass|
          klass.connection_pool.release_connection
        end
      end

      private

      # @return [Hash{Symbol => Class<ActiveRecord::Base>}] Database connection classes to track for fiber variables.
      def databases
        @databases ||= {
          primary: ApplicationRecord,
          cache: SolidCache::Record,
          queue: GoodJob::BaseRecord,
        }
      end

      # @param [Class<ActiveRecord::Base>] klass
      # @return [Hash]
      def connected_to_for(klass)
        {
          role: klass.current_role,
          shard: klass.current_shard,
          prevent_writes: klass.current_preventing_writes,
        }
      end
    end
  end
end
