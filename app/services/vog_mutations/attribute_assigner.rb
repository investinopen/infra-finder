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

    # @param [ApplicationRecord] model
    # @param [{ Symbol => Object }] args
    # @return [ApplicationRecord]
    def call(model, **args)
      attributes = process_attachments_for model, **args

      model.assign_attributes(attributes)

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
