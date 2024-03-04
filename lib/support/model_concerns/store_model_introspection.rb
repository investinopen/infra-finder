# frozen_string_literal: true

# Helper methods for inspecting and working with `StoreModel` attributes.
module StoreModelIntrospection
  extend ActiveSupport::Concern

  included do
    delegate :store_model_attribute_names, to: :class
  end

  # Fetch a hash of only store model attributes for manipulation and introspection.
  # @return [ActiveSupport:HashWithIndifferentAccess{ String, Symbol => StoreModel::Model }]
  def store_model_attributes
    store_model_attribute_names.index_with do |name|
      public_send(name)
    end.with_indifferent_access
  end

  module ClassMethods
    # @return [void]
    def accepts_store_model_list!(*attrs)
      attrs.flatten!.map!(&:to_sym).uniq!

      attrs.each do |attr|
        accept_store_model_list_for!(attr)
      end
    end

    # @!attribute [r] store_model_attribute_names
    # @return [<String>]
    def store_model_attribute_names
      store_model_attribute_types.keys
    end

    # @!attribute [r] store_model_attribute_types
    # @return [{ String => StoreModel::Type::One, StoreModel::Type::Many }]
    def store_model_attribute_types
      @store_model_attribute_types ||= attribute_types.select { |_, v| v.kind_of?(StoreModel::Types::One) || v.kind_of?(StoreModel::Types::Many) }
    end

    private

    def accept_store_model_list_for!(attr)
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{attr}_attributes=(new_attributes)
        self.#{attr} = Array(new_attributes).compact_blank
      end
      RUBY
    end
  end
end
