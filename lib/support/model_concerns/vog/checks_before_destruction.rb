# frozen_string_literal: true

module VOG
  # A concern to determine if a given model has any populated associations
  # with a dependent option set to `:restrict_with_error` or `:restrict_with_exception`.
  #
  # It is used for easy validation in destroy mutations.
  module ChecksBeforeDestruction
    extend ActiveSupport::Concern

    # @param [Symbol] name
    def has_existing_association?(name)
      association(name).scope.exists?
    end

    def has_protected_dependents?
      protected_dependents.any?
    end

    def protected_dependents
      self.class.protected_associations.each_with_object([]) do |assoc, names|
        names << assoc.name if has_existing_association?(assoc.name)
      end
    end

    module ClassMethods
      # @return [<ActiveRecord::Reflection::HasManyReflection>]
      def protected_associations
        @protected_associations ||= reflect_on_all_associations.select do |assoc|
          /\Arestrict_with/.match? assoc.options[:dependent]
        end
      end
    end
  end
end
