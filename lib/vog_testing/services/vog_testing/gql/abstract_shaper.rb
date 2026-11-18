# frozen_string_literal: true

module VOGTesting
  module GQL
    # @abstract
    class AbstractShaper
      include RSpec::Matchers

      def object(...)
        ::VOGTesting::GQL::ObjectShaper.build(...)
      end

      def objects(...)
        ::VOGTesting::GQL::ObjectsShaper.build(...)
      end

      alias array objects
    end
  end
end
