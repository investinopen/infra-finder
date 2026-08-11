# frozen_string_literal: true

# Helper methods for inspecting and working with `StoreModel` attributes.
module StoreModelIntrospection
  extend ActiveSupport::Concern

  include StoreModel::NestedAttributes

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
    # @!attribute [r] store_model_attribute_names
    # @return [<String>]
    def store_model_attribute_names = store_model_attribute_types.keys
  end
end
