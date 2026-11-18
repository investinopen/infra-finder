# frozen_string_literal: true

module VOGTesting
  class GQLShaper < VOGTesting::GQL::AbstractShaper
    # @return [VOGTesting::GQL::TopLevelErrorsShaper]
    attr_reader :top_level

    def initialize(...)
      super

      @top_level = ::VOGTesting::GQL::TopLevelErrorsShaper.new
    end

    alias query object

    def attribute_errors(...)
      ::VOGTesting::GQL::AttributeErrorsBuilder.build(...)
    end

    def attribute_error_on(...)
      ::VOGTesting::GQL::AttributeErrorBuilder.build(...)
    end

    def mutation(...)
      ::VOGTesting::GQL::MutationShaper.build(...)
    end

    def named(...)
      ::VOGTesting::GQL::NamedObjectShaper.build(...)
    end

    # @param [String, Symbol] name
    # @return [Hash]
    def empty_mutation(name)
      query do |q|
        q[name] = nil
      end
    end
  end
end
