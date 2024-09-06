# frozen_string_literal: true

module Solutions
  module Revisions
    class Attachment
      include Support::EnhancedStoreModel

      include ActionView::Helpers::NumberHelper

      filter_attributes! /\Adata_uri\z/, /\Aoriginal_import_url\z/

      METADATA_KEYS = %w[
        filename
        mime_type
        original_import_url
        sha256
        size
      ].freeze

      attribute :data_uri, :string

      attribute :filename, :string

      attribute :mime_type, :string
      attribute :original_import_url, :string
      attribute :sha256, :string
      attribute :size, :big_integer

      alias_attribute :content_type, :mime_type

      def empty_attachment?
        !valid_attachment? || size == 0
      end

      def to_description
        return unless data_uri? && filename? && size?

        "#{filename} (#{number_to_human_size(size)})"
      end

      def valid_attachment?
        data_uri? && filename? && size?
      end

      class << self
        # @param [Shrine::UploadedFile] file
        # @return [Solutions::Revisions::Attachment, nil]
        def from(file)
          case file
          in Shrine::UploadedFile
            from_uploaded_file(file)
          else
            return nil
          end
        end

        private

        # @param [Shrine::UploadedFile] file
        # @return [{ Symbol => Object }]
        def extract_metadata_from(file)
          file.metadata.slice(*METADATA_KEYS).symbolize_keys
        end

        # @param [Shrine::UploadedFile] file
        # @return [Solutions::Revisions::Attachment]
        def from_uploaded_file(file)
          data_uri = file.data_uri

          attrs = extract_metadata_from(file)

          new(**attrs, data_uri:)
        end
      end
    end
  end
end
