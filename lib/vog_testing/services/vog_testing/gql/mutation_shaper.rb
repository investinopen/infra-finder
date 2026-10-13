# frozen_string_literal: true

module VOGTesting
  module GQL
    class MutationShaper < NamedObjectShaper
      include Predications

      option :no_errors, Dry::Types["bool"], default: proc { true }
      option :no_global_errors, Dry::Types["bool"], default: proc { true }

      before_build :check_errors!

      def attribute_errors(...)
        body[:attribute_errors] = AttributeErrorsBuilder.build(...)

        return self
      end

      alias errors attribute_errors

      def global_errors(...)
        body[:global_errors] = GlobalErrorsBuilder.build(...)

        return self
      end

      private

      # @return [void]
      def check_errors!
        body[:attribute_errors] = be_blank if no_errors
        body[:global_errors] = be_blank if no_global_errors
      end
    end
  end
end
