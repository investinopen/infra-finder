# frozen_string_literal: true

module Solutions
  module Revisions
    # @abstract
    class Data
      include Support::EnhancedStoreModel

      actual_enum :version, :v2, :unknown, default: :unknown

      attribute :slug, :string
      attribute :provider_id, :string
      attribute :provider_name, :string
      attribute :solution_id, :string

      alias_attribute :data_version, :version

      # @param [Solutions::Revisions::Data, nil] other
      def has_different_provider_from?(other)
        other.present? && other.provider_id != provider_id
      end
    end
  end
end
