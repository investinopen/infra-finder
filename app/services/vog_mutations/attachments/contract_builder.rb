# frozen_string_literal: true

module VOGMutations
  module Attachments
    # A builder for attachment contracts used in VOG mutations.
    #
    # It automatically adds rules to prevent simultaneous
    # updating and clearing of an attachment.
    #
    # @api private
    class ContractBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :name, ::Support::GlobalTypes::Symbol

        option :image, ::Support::GlobalTypes::Bool, default: false, optional: true
      end

      # @return [ApplicationContract]
      def call
        attachment_name = name

        clear_attachment = :"clear_#{name}"

        contract = Class.new(ApplicationContract) do
          json do
            optional(clear_attachment).maybe(:bool)
            optional(attachment_name).maybe(:hash)
          end

          rule(clear_attachment, attachment_name) do
            key(attachment_name).failure(:update_and_clear_attachment) if values[clear_attachment].present? && values[attachment_name].present?
          end
        end

        contract.new
      end
    end
  end
end
