# frozen_string_literal: true

module VOG
  # Helpers for defining certain types of associations.
  module AssociationHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # @param [Symbol] name
      # @param [Class] model_klass
      # @return [Boolean] whether the association with the given name
      def associated_against?(name, model_klass)
        has_association_for?(name) { _1.klass == model_klass }
      end

      # @param [Symbol] name
      # @param [Symbol] association_name
      # @param [Symbol] target_name
      # @return [void]
      def delegate_scope!(name, association_name, target_name: name)
        scope_definition = ->(*args, **kwargs) do
          association = reflect_on_association(association_name)

          delegated = association.klass.public_send(target_name, *args, **kwargs)

          if association.has_one? || association.belongs_to?
            joins(association_name).merge(delegated)
          else
            where(id: delegated.select(association.foreign_key))
          end
        end

        scope name, scope_definition
      end

      # @see #delegate_scope!
      # @param [<Symbol>] names the names of the scopes to delegate
      # @param [Symbol] to the association to delegate to
      # @return [void]
      def delegate_scopes!(*names, to:)
        names.each do |name|
          delegate_scope! name, to
        end
      end

      # @param [Symbol] name
      # @param [Symbol] association_name
      # @param [Symbol] scope_name
      # @return [void]
      def delegate_lookup!(name, association_name, scope_name: :"lookup_by_#{name}")
        delegate_scope! scope_name, association_name
      end

      # @see #delegate_lookup!
      # @param [<Symbol>] names the names of the lookups to delegate
      # @param [Symbol] to the association to delegate to
      # @return [void]
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
      def belongs_to_readonly(name, *args, **kwargs, &)
        belongs_to(name, *args, **kwargs, &)
      end

      # @param [Symbol] association_name
      # @yieldreturn [Boolean]
      # @return [Boolean] whether the model has an association with the given name
      def has_association_for?(association_name)
        assoc = reflect_on_association(association_name)

        return false if assoc.blank?

        block_given? ? yield(assoc) : true
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
      def has_many_readonly(name, *args, **kwargs, &)
        has_many(name, *args, **kwargs, &)
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
      def has_one_readonly(name, *args, **kwargs, &)
        has_one(name, *args, **kwargs, &)
      end
    end
  end
end
