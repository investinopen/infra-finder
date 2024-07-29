# frozen_string_literal: true

module Solutions
  class AttributeExtractor < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :source, Types::AnySolution
    end

    standard_execution!

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :attributes

    # @return [Dry::Monads::Success(ActiveSupport::HashWithIndifferentAccess)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield extract!
      end

      Success attributes
    end

    wrapped_hook! def prepare
      @attributes = {}.with_indifferent_access

      super
    end

    wrapped_hook! def extract
      SolutionProperty.to_clone.each do |attr|
        attributes[attr] = source.__send__(attr)
      end

      super
    end
  end
end
