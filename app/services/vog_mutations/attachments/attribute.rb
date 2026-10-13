# frozen_string_literal: true

module VOGMutations
  module Attachments
    # An attachment attribute definition for VOG mutations.
    class Attribute
      include Dry::Core::Equalizer.new(:name)
      include Support::Typing

      include Dry::Initializer[undefined: false].define -> do
        param :name, ::Support::GlobalTypes::Symbol

        option :image, ::Support::GlobalTypes::Bool, default: false, optional: true
      end

      # Assign attachment values to a given model and mutably
      # alter the provided `args`, so that they can later be used
      #
      # @note `args` is mutated by this method, as it deletes keys
      #   that are consumed by attachments.
      # @param [ApplicationRecord] model
      # @param [{ Symbol => Object }] args
      # @return [void]
      def assign!(model, args)
        attacher = attacher_for model

        file = args.delete name

        should_clear = args.delete clear

        new_metadata = prepare_metadata args.delete metadata

        if file.present?
          # Replace file and maybe update metadata
          attacher.model_assign file

          attacher.add_metadata new_metadata if new_metadata.present?
        elsif should_clear
          # Clear the file, ignore metadata
          attacher.assign nil
        elsif attacher.attached? && new_metadata.present?
          # Update metadata only
          attacher.add_metadata new_metadata
        end
      end

      # @param [ApplicationRecord] model
      # @return [Shrine::Attacher]
      def attacher_for(model)
        model.public_send(:"#{name}_attacher")
      end

      # @!attribute [r] clear
      # @return [Symbol] the clear attribute name for this attachment
      def clear = :"clear_#{name}"

      # @!attribute [r] contract
      # @see VOGMutations::Attachments::ContractBuilder
      # @return [ApplicationContract] the contract for this attachment
      def contract
        @contract ||= build_contract
      end

      # @!attribute [r] metadata
      # @return [Symbol] the metadata attribute name for this attachment
      def metadata = :"#{name}_metadata"

      private

      # @see VOGMutations::Attachments::ContractBuilder
      # @return [ApplicationContract]
      def build_contract
        ContractBuilder.new(name, image:).call
      end

      # @param [VOGMutations::Attachments::Attribute] attachment
      # @param [Hash, nil] value
      # @return [{ String => Object }, nil]
      def prepare_metadata(value)
        # simplecov:disable
        return nil unless image
        # simplecov:enable

        Common::Container["image_attachments.sanitize_metadata"].call value
      end
    end
  end
end
