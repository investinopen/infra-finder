# frozen_string_literal: true

module VOG
  # A concern for deriving & accessing the conventions-based service/operation namespace for a model.
  #
  # This is intended to be included on {ApplicationRecord} and used by all models.
  #
  # By default, the namespace is derived from the model's name by pluralizing it. For example, `User` would have a namespace of `Users`.
  # This can be overridden by setting the `vog_namespace_name` class attribute like so:
  #
  # ```ruby
  # class User < ApplicationRecord
  #   vog_namespace_name "Accounts"
  # end
  # ```
  module Namespacing
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      # @!attribute [r] vog_namespace_name
      # @!scope class
      # @return [String, nil]
      defines :vog_namespace_name, type: ::Support::Types::String.optional
    end

    # @see .vog_namespace
    def vog_namespace = self.class.vog_namespace

    # @see .vog_namespace_path
    def vog_namespace_path = self.class.vog_namespace_path

    # @see .vog_namespaced
    def vog_namespaced(...) = self.class.vog_namespaced(...)

    # @see .vog_namespaced_operation
    def vog_namespaced_operation(...) = self.class.vog_namespaced_operation(...)

    # @see .vog_namespaced_path
    def vog_namespaced_path(...) = self.class.vog_namespaced_path(...)

    module ClassMethods
      def inherited(subclass)
        super

        subclass.derive_vog_namespace_name!
      end

      # @!attribute [r] vog_namespace_name
      # @!scope class
      # @return [Module, nil] The namespace under which to look for services/operations related to this model.
      def vog_namespace = "::#{vog_namespace_name}".safe_constantize

      # @!attribute [r] vog_namespace_path
      # @!scope class
      # @return [String, nil] The namespace path under which to look for operations/services
      def vog_namespace_path = vog_namespace_name.underscore

      # @param [<String>] service_or_operation_names
      # @return [Module, nil] The namespace under which to look for services/operations
      def vog_namespaced(*service_or_operation_names)
        [vog_namespace, *service_or_operation_names].compact_blank.join("::").safe_constantize
      end

      # @param [<String>] service_or_operation_names
      # @return [String, nil] The namespace path under which to look for operations
      def vog_namespaced_path(*parts)
        [vog_namespace_path, *parts].compact_blank.join(?/)
      end

      # Grab a dotted operation path suitable for use with {Support::CallsCommonOperation}, using the namespace of this model.
      #
      # @param [<String>] service_or_operation_names
      # @return [String, nil] The dotted path for the given operation
      def vog_namespaced_operation(...) = vog_namespaced_path(...).tr(?/, ?.)

      protected

      # @return [String] The name of the namespace under which to look for services/operations related to this model.
      def derive_vog_namespace_name
        name&.pluralize
      end

      # @return [void]
      def derive_vog_namespace_name!
        vog_namespace_name derive_vog_namespace_name
      end
    end
  end
end
