# frozen_string_literal: true

module EncodedSets
  class Reference
    include Support::EnhancedStoreModel

    attribute :id, :string
    attribute :encoded_id, :string
    attribute :type, :string
    attribute :name, :string
    attribute :slug, :string
    attribute :identifier, :string

    def initialize(...)
      super

      @cache = Concurrent::Map.new
    end

    def record
      @cache.compute_if_absent :record do
        type.constantize.find_by(id:)
      end
    end

    class << self
      def from(input)
        case input
        in self then input
        in nil then nil
        in ApplicationRecord => record
          from_model(record)
        else
          raise ArgumentError, "Cannot create an encoded reference from #{record.class.name}"
        end
      end

      # @param [ApplicationRecord] record
      # @return [Reports::Common::EncodedReference]
      def from_model(record)
        new(
          id: record.id,
          encoded_id: record.to_encoded_id,
          type: record.class.name,
          name: record.try(:name),
          slug: record.try(:system_slug),
          identifier: record.try(:identifier)
        )
      end
    end
  end
end
