# frozen_string_literal: true

module VOGMutations
  # Assigns attributes to a model, processing any attachment attributes as needed.
  #
  # @see VOGMutations::Attachments::Attribute
  # @api private
  class AttributeAssigner
    include Dry::Initializer[undefined: false].define -> do
      option :attachments, ::VOGMutations::Attachments::Attribute::List
    end

    # Raised after assigning every attribute when one or more assignments saved an
    # invalid associated record.
    class Invalid < StandardError
      # @return [{ Symbol => ActiveRecord::Base }] each failed attribute and its invalid record
      attr_reader :failures

      # @param [{ Symbol => ActiveRecord::Base }] failures
      def initialize(failures)
        @failures = failures

        super("could not assign #{failures.keys.to_sentence}")
      end
    end

    # @param [ApplicationRecord] model
    # @param [{ Symbol => Object }] args
    # @raise [VOGMutations::AttributeAssigner::Invalid]
    # @return [ApplicationRecord]
    def call(model, **args)
      attributes = process_attachments_for model, **args

      failures = {}

      # Attributes are assigned one at a time so that a failure can be tied to its input:
      # assigning a has-many-through association on a saved model inserts the join rows
      # immediately, and their validations raise. The rest are still assigned, so the
      # model's own validations can report on them too.
      attributes.each do |attribute, value|
        model.assign_attributes(attribute => value)
      rescue ActiveRecord::RecordInvalid => e
        failures[attribute.to_sym] = e.record
      end

      raise Invalid.new(failures) if failures.any?

      return model
    end

    private

    # @see VOGMutations::Attachments::Attribute#assign!
    # @param [ApplicationRecord] model
    # @param [{ Symbol => Object }] args
    # @return [{ Symbol => Object }]
    def process_attachments_for(model, **args)
      # simplecov:disable
      return args if attachments.blank?
      # simplecov:enable

      attachments.each do |attachment|
        # NOTE: this will mutate `args`
        attachment.assign! model, args
      end

      return args # remaining attributes
    end
  end
end
