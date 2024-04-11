# frozen_string_literal: true

module SolutionImports
  module Legacy
    module Transformations
      extend Dry::Transformer::Registry

      import Dry::Transformer::HashTransformations

      TRY_YEAR_TO_DATE = ->(value) do
        Types::Params::Date.try("#{value}-01-01").to_monad.value_or(nil)
      end

      class << self
        def compose_implementation(hash, implementation, options)
          InfraFinder::Container["solution_imports.legacy.compose_implementation"].(hash, implementation, **options).value_or(hash)
        end

        # @param [Hash] hash
        # @return [Hash]
        def normalize_maintenance_status(hash)
          id = hash.delete :maintenance_status_id

          hash[:maintenance_status] = id.to_s == ?1 ? "active" : "unknown"

          return hash
        end

        # @param [Hash] hash
        # @return [Hash]
        def normalize_multiple_options(hash)
          SolutionInterface::MULTIPLE_OPTIONS.reduce(hash) do |h, option|
            assoc = Solution.reflect_on_association(option)

            klass = assoc.klass

            normalize_multiple_option(h, klass)
          end
        end

        # @param [Hash] hash
        # @param [Class<SolutionOption::Multiple>] klass
        # @return [Hash]
        def normalize_multiple_option(hash, klass)
          source_key = klass.legacy_import_source_key

          target_key = klass.model_name.plural.to_sym

          raw_value = hash.delete(source_key)

          records = InfraFinder::Container["solution_imports.legacy.lookup_multiple_options"].(klass, raw_value).value_or([])

          hash[target_key] = records

          return hash
        end

        # @param [Hash] hash
        # @return [Hash]
        def normalize_single_options(hash)
          SolutionInterface::SINGLE_OPTIONS.reduce(hash) do |h, option|
            assoc = Solution.reflect_on_association(option)

            klass = assoc.klass

            normalize_single_option(h, klass)
          end
        end

        # @see SolutionOption::Single::ClassMethods#normalize_legacy_import!
        # @param [Hash] hash
        # @param [Class<SolutionOption::Single>] klass
        # @return [Hash]
        def normalize_single_option(hash, klass)
          klass.normalize_legacy_import!(hash)
        end

        # @param [Hash] hash
        # @return [Hash]
        def parse_comparable_products(hash)
          map_value_with(hash, :comparable_products, "solution_imports.legacy.parse_comparable_products", [])
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def parse_financial_information_scope(hash, key)
          map_value_with hash, key, "solution_imports.legacy.parse_financial_information_scope", "unknown"
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def parse_financial_numbers_applicability(hash, key)
          map_value_with hash, key, "solution_imports.legacy.parse_financial_numbers_applicability", "unknown"
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def parse_financial_numbers_publishability(hash, key)
          map_value_with hash, key, "solution_imports.legacy.parse_financial_numbers_publishability", "unknown"
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def parse_institutions_in(hash, key)
          map_value_with(hash, key, "solution_imports.legacy.parse_institutions", [])
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def parse_grants_in(hash, key)
          map_value_with(hash, key, "solution_imports.legacy.parse_grants", [])
        end

        # @param [Hash] hash
        # @return [Hash]
        def parse_recent_grants(hash)
          parse_grants_in(hash, :recent_grants)
        end

        # @param [Hash] hash
        # @return [Hash]
        def parse_service_providers(hash)
          url = hash.delete(:link_to_service_desc_or_service_provider_registry)

          provider = { name: url, url:, }.compact_blank.presence

          hash[:service_providers] = [provider].compact_blank

          return hash
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @param [String] operation name of the operation to run with the current value
        # @param [Object] fallback
        # @return [Hash]
        def map_value_with(hash, key, operation, fallback)
          self[:map_value].(hash, key, ->(input) do
            InfraFinder::Container[operation].(input).value_or(fallback)
          end)
        end

        # @param [Hash] hash
        # @param [Symbol] key
        # @return [Hash]
        def year_to_date(hash, key)
          self[:map_value].(hash, key, TRY_YEAR_TO_DATE)
        end
      end
    end
  end
end
