# frozen_string_literal: true

module Solutions
  module Revisions
    class DataExtractor < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :solution, Types::Actual
      end

      CURRENT_VERSION = "v2"

      standard_execution!

      delegate :provider, :provider_id, :provider_name, :slug, to: :solution
      delegate :id, to: :solution, prefix: true

      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :properties

      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :data

      # @return [Dry::Monads::Success(Solutions::Revisions::V2Data)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield extract!
        end

        Success Solutions::Revisions::V2Data.new(data)
      end

      wrapped_hook! def prepare
        @properties = {}.with_indifferent_access

        @data = {
          version: CURRENT_VERSION,
          provider_id:,
          provider_name:,
          solution_id:,
          slug:,
          properties:,
        }.with_indifferent_access

        super
      end

      wrapped_hook! def extract
        raw_attributes = yield solution.extract_attributes

        raw_attributes.merge!(solution.slice(:publication).stringify_keys)

        raw_attributes.each do |property_name, value|
          changeset = cast_property_for_revision(property_name, value)

          properties.merge!(changeset)
        end

        super
      end

      private

      def cast_property_for_revision(property_name, value)
        {
          property_name => cast_value_for_revision(value)
        }
      end

      def cast_value_for_revision(value)
        case value
        in Shrine::UploadedFile
          Solutions::Revisions::Attachment.from(value)
        in ControlledVocabularies::Types::Record
          value.term
        in ControlledVocabularies::Types::RecordSet
          value.pluck(:term)
        else
          value.as_json
        end
      end
    end
  end
end
