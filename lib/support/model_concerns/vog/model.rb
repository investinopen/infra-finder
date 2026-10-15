# frozen_string_literal: true

module VOG
  # A concern intended to be included on {ApplicationRecord}.
  module Model
    extend ActiveSupport::Concern

    include VOG::AssociationHelpers
    include VOG::ChecksBeforeDestruction
    include VOG::ColumnHandling
    include VOG::Filterable
    include VOG::GraphQLModelSupport
    include VOG::IdQuoting
    include VOG::LazyOrdering
    include VOG::LookupHelpers
    include VOG::ManagedColumns
    include VOG::ModelMutationSupport
    include VOG::Namespacing
    include VOG::StoreModelIntrospection
    include VOG::VirtualColumnHandling
    include Support::CallsCommonOperation
    include Support::Caching::Usage
    include DistinctOnOrderValues
    include LimitToOne
    include WhereMatches
    include WithAdvisoryLock::Concern

    included do
      extend ArelHelpers
      extend DefinesMonadicOperation
      extend Support::ValueSelect::ModelIntegration
    end

    module ClassMethods
      # Sometimes we need to get a count on something that has aggregations,
      # `DISTINCT ON`, etc. This should handle most cases.
      # @param [Boolean] strip_order
      # @return [Integer]
      def count_from_subquery(strip_order: false)
        subquery = all

        subquery = subquery.reorder(nil) if strip_order

        unscoped.from(subquery).count
      end

      # @api private
      # @note Only used for tests
      def default_factory
        # simplecov:disable
        model_name.i18n_key
        # simplecov:enable
      end

      # @param [<ApplicationRecord>] records
      # @return [ActiveRecord::Relation<ApplicationRecord>]
      def limited_to(*records)
        return all if records.flatten.blank?

        id = records.flatten.map do |record|
          case record
          when self then record.id
          when ::Support::GlobalTypes::UUID then record
          end
        end.compact.uniq

        id.blank? ? none : where(id:)
      end

      def sample(num = nil)
        randomized = reorder(Arel.sql("RANDOM()"))

        if num.is_a?(Integer) && num >= 1
          randomized.limit(num)
        else
          randomized.first
        end
      end

      alias scoped_sample sample
    end
  end
end
