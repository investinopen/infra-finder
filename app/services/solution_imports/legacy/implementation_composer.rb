# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ImplementationComposer < Support::HookBased::Actor
      extend Dry::Core::Cache

      DEFAULT_URL_KEYS = proc do
        if url_key_prefix.present? && !skip_urls
          %i[displayed hidden_one hidden_two].map do |suffix|
            [url_key_prefix, suffix].join(?_).to_sym
          end
        else
          []
        end
      end

      include Dry::Initializer[undefined: false].define -> do
        param :row, Types::Hash

        param :implementation, Types::Implementation

        option :extra_keys, Types::Coercible::Array.of(Types::Coercible::Symbol), default: proc { [] }

        option :skip_urls, Types::Bool, default: proc { false }

        option :url_key_prefix, Types::Symbol.optional, default: proc { :"link_to_#{implementation}" }

        option :statement_key, Types::Symbol.optional, optional: true

        option :status_key, Types::Symbol.optional, optional: true

        option :url_keys, Types::Coercible::Array.of(Types::Coercible::Symbol), default: DEFAULT_URL_KEYS

        option :autostatus, Types::Bool, default: proc { status_key.nil? }
      end

      standard_execution!

      include InfraFinder::Deps[
        parse_implementation_status: "solution_imports.parse_implementation_status",
      ]

      # @return [Solution::ImplementationDetail]
      attr_reader :details

      # @return [Symbol]
      attr_reader :implementation_key

      # @return [Symbol]
      attr_reader :implementation_status_key

      # @return [Hash]
      attr_reader :data

      # @return [<String>]
      attr_reader :invalid_urls

      # @return [String, nil]
      attr_reader :statement

      # @return [SolutionImports::Types::ImplementationStatus]
      attr_reader :status

      # @return [<String>]
      attr_reader :urls

      delegate :has_any_links?, :has_many_links?, :has_no_links?, :has_single_link?, :has_statement?, :link_mode, :linked?, :unlinked?, to: :details

      def call
        run_callbacks :execute do
          yield prepare!

          yield extract!

          yield compose!

          yield store!
        end

        Success row
      end

      wrapped_hook! def prepare
        @details = Solution.implementations.detect { _1.name.to_s == implementation }

        # :nocov:
        return Failure[:unknown_implementation, implementation] if @details.blank?
        # :nocov:

        @implementation_status_key = details.enum

        @implementation_key = details.name

        @data = {}

        @statement = nil

        @status = "unknown"

        @urls = []

        @invalid_urls = []

        super
      end

      wrapped_hook! def extract
        yield extract_statement!
        yield extract_status!
        yield extract_urls!
        yield extract_extra!

        super
      end

      wrapped_hook! :compose

      wrapped_hook! def store
        row[implementation_status_key] = status
        row[implementation_key] = data

        super
      end

      after_compose :set_links!, if: :has_many_links?
      after_compose :set_link!, if: :has_single_link?
      after_compose :set_statement!, if: :has_statement?
      after_compose :derive_status!, if: :autostatus

      private

      # @return [void]
      def derive_status!
        @status = urls.present? ? "available" : "unknown"
      end

      # @return [void]
      def extract_extra!
        extra_keys.each do |key|
          value = row.delete(key)

          case key
          when :this_web_accessibility_statement_applies_to_id
            @data[:applies_to_website] = value == 1
            @data[:applies_to_project] = value == 2
          when
            # :nocov:
            @data.compact_blank
            # :nocov:
          end
        end

        Success()
      end

      # @return [void]
      def extract_statement!
        @statement = row.delete(statement_key) if statement_key.present?

        Success()
      end

      def extract_status!
        # :nocov:
        value = row.delete(status_key) if status_key.present?

        return Success() if value.blank?
        # :nocov:

        @status = parse_implementation_status.(value)

        Success()
      end

      # @return [void]
      def extract_urls!
        url_keys.each do |key|
          url = row.delete key

          next if url.blank?

          case url
          when Types::URL
            urls << url
          else
            invalid_urls << url
          end
        end

        urls.compact_blank!
        urls.uniq!

        Success()
      end

      # @return [void]
      def set_link!
        url = urls.first

        data[:link] = { url:, }.compact_blank
      end

      # @return [void]
      def set_links!
        data[:links] = urls.map do |url|
          { url:, }
        end
      end

      # @return [void]
      def set_statement!
        data[:statement] = [*invalid_urls, statement].compact_blank.join("\n")
      end
    end
  end
end
