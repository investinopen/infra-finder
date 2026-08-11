# frozen_string_literal: true

module Support
  module WithStrongParamSet
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :strong_params_default_allowed, type: Support::Types::Bool
      defines :strong_param_set, type: Support::StrongParamSet::Type

      strong_params_default_allowed true

      strong_param_set Support::StrongParamSet.new
    end

    module ClassMethods
      # @return [<Symbol, Hash>]
      def strong_params = strong_param_set.to_a

      # @api private
      # @param [Class<WithStrongParamSet>] subclass
      # @return [void]
      def inherited(subclass)
        super

        subclass.strong_param_set strong_param_set.dup
      end
    end
  end
end
