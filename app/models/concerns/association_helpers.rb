# frozen_string_literal: true

# Helpers for defining certain types of associations.
# rubocop:disable Rails/HasManyOrHasOneDependent
module AssociationHelpers
  extend ActiveSupport::Concern

  class_methods do
    def delegate_scope!(name, association_name, target_name: name)
      scope_definition = ->(input) do
        association = reflect_on_association(association_name)

        delegated = association.klass.public_send(target_name, input)

        joins(association_name).merge(delegated)
      end

      scope name, scope_definition
    end

    def delegate_scopes!(*names, to:)
      names.each do |scope|
        delegate_scope! name, to
      end
    end

    def delegate_lookup!(name, association_name, scope_name: :"lookup_by_#{name}")
      delegate_scope! scope_name, association_name
    end

    def delegate_lookups!(*names, to:)
      names.each do |name|
        delegate_lookup! name, to
      end
    end

    # Define a read-only `belongs_to` association
    #
    # @param [Symbol] name
    # @param [<Object>] args
    # @param [{ Symbol => Object }] kwargs
    # @yield Set up the belongs_to association
    # @yieldreturn [void]
    # @!macro [attach] belongs_to_readonly
    #   @!parse ruby
    #     # @note This association is read-only (likely against a database view).
    #     belongs_to $1, -> { readonly }, ${2--1}
    def belongs_to_readonly(...)
      belongs_to(...)
    end

    # Define a read-only `has_many` association.
    #
    # @param [Symbol] name
    # @param [<Object>] args
    # @param [{ Symbol => Object }] kwargs
    # @yield Set up the has_many association
    # @yieldreturn [void]
    # @!macro [attach] has_many_readonly
    #   @!parse ruby
    #     # @note This association is read-only (likely against a database view).
    #     has_many $1, -> { readonly }, ${2--1}
    def has_many_readonly(...)
      has_many(...)
    end

    # Define a read-only `has_one` association
    #
    # @param [Symbol] name
    # @param [<Object>] args
    # @param [{ Symbol => Object }] kwargs
    # @yield Set up the has_one association
    # @yieldreturn [void]
    # @!macro [attach] has_one_readonly
    #   @!parse ruby
    #     # @note This association is read-only (likely against a database view).
    #     has_one $1, -> { readonly }, ${2--1}
    def has_one_readonly(...)
      has_one(...)
    end
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
