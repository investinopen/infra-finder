# frozen_string_literal: true

module Admin
  module StoreModelLogic
    extend ActiveSupport::Concern

    # @return [Symbol]
    attr_reader :attr

    # @return [Hash]
    attr_reader :options

    # @return [Class]
    attr_reader :store_model_type

    def default_heading
      @attr.to_s.titleize
    end

    # @api private
    # @return [Class]
    def find_store_model_type!
      key = attr.to_s

      obj = __getobj__.object

      atype =
        case obj
        when ::ApplicationRecord
          obj.class.store_model_attribute_types.fetch(key)
        when ::StoreModel::Model
          obj.class.attribute_types.fetch(key)
        else
          # :nocov:
          raise "Cannot derive store model attribute type from #{obj.inspect}"
          # :nocov:
        end

      atype.model_klass
    end

    # @api private
    def without_wrapper
      is_being_wrapped = already_in_an_inputs_block

      self.already_in_an_inputs_block = false

      yield
    ensure
      self.already_in_an_inputs_block = is_being_wrapped
    end
  end
end
