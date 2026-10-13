# frozen_string_literal: true

module Support
  module Caching
    # A caching mechanism for GraphQL requests that is safe to use
    # within the context of a request, whether it dips into threads or fibers.
    #
    # @api private
    class Cache
      CACHE_METHODS = %i[
        cleanup
        clear
        decrement
        delete
        delete_matched
        delete_multi
        exist?
        fetch
        fetch_multi
        increment
        read
        read_counter
        read_multi
        write
        write_counter
        write_multi
      ].freeze

      delegate *CACHE_METHODS, to: :vog_safe_cache

      def vog_cache(name, with_rails: false, **options, &)
        fetch(name, **options) do
          if with_rails
            Rails.cache.fetch(name, **options, &)
          else
            yield
          end
        end
      end

      # Activates the VOG cache for the duration of the block
      # within fiber-local storage.
      # @return [void]
      def with_vog_cache
        # simplecov:disable
        return yield if vog_safe_cache_active?
        # simplecov:enable

        with_vog_safe_cache_active! do
          with_cache! do
            yield
          end
        end
      end

      # @!attribute [r] vog_safe_cache_active
      # @return [Boolean]
      def vog_safe_cache_active
        Fiber[:vog_safe_cache_active] || false
      end

      alias vog_safe_cache_active? vog_safe_cache_active

      alias vog_cache_active? vog_safe_cache_active

      # @!attribute [r] vog_safe_cache
      # This will be either a MemoryStore or a NullStore, based on whether or not {#vog_safe_cache_active}.
      # @return [ActiveSupport::Cache::Store]
      def vog_safe_cache
        Fiber[:vog_safe_cache] || null_store
      end

      # @return [void]
      def with_cache!
        original = Fiber[:vog_safe_cache]

        Fiber[:vog_safe_cache] = ActiveSupport::Cache::MemoryStore.new

        yield
      ensure
        Fiber[:vog_safe_cache] = original
      end

      # @return [void]
      def with_vog_safe_cache_active!
        original = vog_safe_cache_active

        Fiber[:vog_safe_cache_active] = true

        yield
      ensure
        Fiber[:vog_safe_cache_active] = original
      end

      private

      # @return [ActiveSupport::Cache::NullStore]
      def null_store
        @null_store ||= ActiveSupport::Cache::NullStore.new
      end

      class << self
        # @return [Support::Caching::Cache]
        def instance
          @instance ||= new
        end

        delegate_missing_to :instance
      end
    end
  end
end
