# frozen_string_literal: true

module VOGMutations
  # Mixin that encapsulates attribute extraction capabilities for a {VOGMutations::Implementation implementation}.
  module AttributeExtraction
    extend ActiveSupport::Concern

    include VOGMutations::Contracts

    included do
      delegate :attribute_assigner, to: :class
    end

    # When assigning saved an invalid associated record, reports that record's errors on
    # the input that was being assigned, along with the model's own errors, and halts.
    #
    # @see VOGMutations::AttributeAssigner#call
    # @raise [VOGMutations::Halting::Invalid] if assigning saved an invalid associated record
    def assign_attributes!(model, **args)
      attribute_assigner.call model, **args
    rescue VOGMutations::AttributeAssigner::Invalid => e
      e.failures.each do |attribute, record|
        record.errors.each do |error|
          add_attribute_error! error.message, path: attribute, code: (error.type if error.type.kind_of?(Symbol))
        end
      end

      model.validate

      # The failed join record is still loaded, so the model also reports its join
      # association as invalid, which repeats the error already reported above.
      e.failures.each_key do |attribute|
        through = model.class.reflect_on_association(attribute)&.options&.[](:through)

        model.errors.delete(through) if through
      end

      add_model_errors! model

      throw_invalid
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
