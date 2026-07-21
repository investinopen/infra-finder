# frozen_string_literal: true

module Snowflakes
  # @see Snowflakes::Generator
  class Generate
    # @return [Integer]
    def call
      generator.call
    end

    private

    def generator = self.class.generator

    class << self
      def generator
        @generator ||= Snowflakes::Generator.new
      end
    end
  end
end
