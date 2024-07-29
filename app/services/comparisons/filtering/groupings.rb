# frozen_string_literal: true

module Comparisons
  module Filtering
    module Groupings
      extend ActiveSupport::Concern

      included do
        extend Dry::Core::Cache
        extend Dry::Core::ClassAttributes

        defines :search_filter_groupings, type: Comparisons::Types::SearchFilterGroupings
        defines :search_filter_mapping, type: Comparisons::Types::SearchFilterMapping

        search_filter_groupings({}.freeze)

        search_filter_mapping({}.freeze)

        before_validation :prune_arrays!
      end

      # @param [ActiveRecord::Relation<Solution>] scope
      # @return [Ransack::Search<Solution>]
      def apply_ransack(scope: Solution.all)
        filters = grouped_filters

        Comparisons::Filtering::RansackBuilder.new(scope:, filters:).call.value!
      end

      # @note We can't use ransackable scopes with groupings, so we have
      #   to remap some things to standard ransack predicates. Frustrating,
      #   but it keeps the forms themselves simpler to use scopes, while
      #   having this little extra step here to recombobulate.
      # @see #maybe_remap_for_search
      # @return [{ Comparisons::Types::SearchFilterGrouping => { Symbol => Object } }]
      def grouped_filters
        self.class.search_filter_mapping.transform_values do |attributes|
          attributes.each_with_object({}) do |attr, h|
            key, value = maybe_remap_for_search attr

            next if key.blank? || value.blank?

            h[key] = value
          end
        end.compact_blank
      end

      private

      # @param [Symbol] attr
      # @return [(Symbol, Object), nil]
      def maybe_remap_for_search(attr)
        value = self[attr]

        return [attr, value] unless attr.to_s.in?(ransackable_scopes)

        case attr
        when Implementation.available_scope
          impl = Regexp.last_match[:implementation]

          key = :"#{impl}_implementation_eq"

          return [key, "available"] if value
        when /\Amaintenance_active\z/
          return attr if value
        else
          # :nocov:
          raise ArgumentError, "Unverified scope: #{attr.inspect}"
          # :nocov:
        end
      end

      # @api private
      # @return [void]
      def prune_arrays!
        self.class.array_attributes.each do |attr|
          self[attr] = Array(self[attr]).compact_blank.presence
        end
      end

      def ransackable_scopes
        fetch_or_store :ransackable_scopes do
          Solution.ransackable_scopes
        end
      end

      module ClassMethods
        # @!group Filter Mappers

        # @return [void]
        def community_engagement_filter!(name, ...)
          mapped_filter!(name, :community_engagement)

          attribute(name, ...)
        end

        # @return [void]
        def global_filter!(name, ...)
          mapped_filter!(name, :global)

          attribute(name, ...)
        end

        # @return [void]
        def policy_filter!(name, ...)
          mapped_filter!(name, :policy)

          attribute(name, ...)
        end

        # @return [void]
        def solution_category_filter!(name, ...)
          mapped_filter!(name, :solution_category)

          attribute(name, ...)
        end

        # @return [void]
        def technical_attribute_filter!(name, ...)
          mapped_filter!(name, :technical_attribute)

          attribute(name, ...)
        end

        # @!endgroup

        private

        def attribute(name, ...)
          # :nocov:
          raise UnknownFilter, "Use one of the `<search_filter_grouping>_filter!` methods instead" unless name.in?(search_filter_groupings)
          # :nocov:

          super
        end

        # @param [Symbol] name
        # @param [Comparisons::Types::SearchFilterGrouping] grouping
        # @return [void]
        def mapped_filter!(name, grouping)
          new_groupings = search_filter_groupings.merge(name => grouping)

          search_filter_groupings new_groupings.freeze

          recalculate_search_filter_mapping!
        end

        # @return [void]
        def recalculate_search_filter_mapping!
          new_mapping = Comparisons::Types::SearchFilterGrouping.values.index_with { [] }

          search_filter_groupings.each_with_object(new_mapping) do |(name, grouping), mp|
            mp[grouping] << name
          end

          search_filter_mapping new_mapping.freeze
        end

        # @api private
        class UnknownFilter < StandardError; end
      end
    end
  end
end
