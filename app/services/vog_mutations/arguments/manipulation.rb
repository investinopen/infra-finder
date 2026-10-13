# frozen_string_literal: true

module VOGMutations
  module Arguments
    # @note This module is intended to be `extend`ed.
    module Manipulation
      class << self
        def extended(base)
          # simplecov:disable
          super if defined?(super)
          # simplecov:enable

          base.extend Dry::Core::ClassAttributes

          base.defines :shared_argument_sets, type: ::VOGMutations::Types::SharedArgumentSets

          base.shared_argument_sets Dry::Core::Constants::EMPTY_ARRAY
        end
      end

      # @param [Symbol] attachment_name
      # @return [void]
      def attachment!(attachment_name, desc: "file", required: false, clearable: false)
        argument attachment_name, ::Types::UploadedFileInputType, required: do
          description <<~TEXT.strip_heredoc
          A reference to an uploaded #{desc} in Tus.
          TEXT
        end

        # simplecov:disable
        clearable_attachment! attachment_name if clearable
        # simplecov:enable
      end

      # @return [void]
      def clearable_attachment!(attachment_name, prefix: "clear", **options, &block)
        full_name = [prefix, attachment_name].compact.join(?_).to_sym

        options[:required] = false
        options[:default_value] = false

        options[:description] ||= <<~TEXT.strip_heredoc
        If set to true, this will clear the attachment #{attachment_name} on this model.
        TEXT

        argument full_name, ::GraphQL::Types::Boolean, **options, &block
      end

      # @param [Symbol] attachment_name
      # @return [void]
      def image_attachment!(attachment_name, required: false, clearable: false)
        attachment!(attachment_name, desc: "image", required:, clearable:)

        add_image_metadata_input! attachment_name
      end

      # @api private
      # @param [Symbol] attachment_name
      # @return [void]
      def add_image_metadata_input!(attachment_name)
        full_name = :"#{attachment_name}_metadata"

        options = {}

        options[:required] = false
        options[:description] = <<~TEXT
        Metadata for an image attachment.
        TEXT

        argument(full_name, ::Types::ImageMetadataInputType, **options)
      end

      # @return [void]
      def shared_argument_set(*sets)
        sets.flatten!

        new_sets = shared_argument_sets + sets

        shared_argument_sets new_sets.freeze

        # simplecov:disable
        apply_shared_arguments! if kind_of?(Class)
        # simplecov:enable
      end

      private

      # @return [void]
      def apply_shared_arguments!
        shared_argument_sets.each do |set|
          set.arguments.each_value do |arg|
            arg.apply_to!(self)
          end
        end
      end
    end
  end
end
