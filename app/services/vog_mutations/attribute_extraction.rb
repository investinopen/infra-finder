# frozen_string_literal: true

module VOGMutations
  # Mixin that encapsulates attribute extraction capabilities for a {VOGMutations::Implementation implementation}.
  module AttributeExtraction
    extend ActiveSupport::Concern

    include VOGMutations::Contracts

    included do
      delegate :attribute_assigner, to: :class
    end

    # @see VOGMutations::AttributeAssigner#call
    def assign_attributes!(model, **args)
      attribute_assigner.call model, **args
    end

    # Class methods for {VOGMutations::AttributeExtraction}.
    module ClassMethods
      # @param [Symbol] name
      # @param [{ Symbol => Object }] options
      # @option options [Boolean] :image
      # @return [void]
      def attachment!(name, **options)
        attribute = Attachments::Attribute.new name, **options

        previous = attachments[name]

        if previous.present?
          # simplecov:disable
          warn "Overwriting #{self.class}.attachment #{attribute.name}"

          applicable_contracts.delete previous.contract
          # simplecov:enable
        end

        attachments[name] = attribute

        use_contract! attribute.contract

        rebuild_attribute_assigner!
      end

      # @api private
      # @return [{ Symbol => VOGMutations::Attachments::Attribute }]
      def attachments
        @attachments ||= {}
      end

      # @api private
      # @return [<VOGMutations::Attachments::Attribute>]
      def attachment_attributes
        attachments.values
      end

      # @api private
      # @return [VOGMutations::AttributeAssigner]
      def attribute_assigner
        @attribute_assigner ||= build_attribute_assigner
      end

      private

      # @return [VOGMutations::AttributeAssigner]
      def build_attribute_assigner
        AttributeAssigner.new attachments: attachment_attributes
      end

      # @return [void]
      def rebuild_attribute_assigner!
        @attribute_assigner = build_attribute_assigner
      end
    end
  end
end
