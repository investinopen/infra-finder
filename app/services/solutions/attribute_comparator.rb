# frozen_string_literal: true

module Solutions
  class AttributeComparator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :source, Types::AnySolution
      param :target, Types::AnySolution
    end

    standard_execution!

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :changes

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :source_attributes

    # @return [Solutions::Types::Kind]
    attr_reader :source_kind

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :target_attributes

    # @return [Solutions::Types::Kind]
    attr_reader :target_kind

    # @return [Dry::Monads::Success(ActiveSupport::HashWithIndifferentAccess)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield extract!

        yield compare!
      end

      Success changes
    end

    wrapped_hook! def prepare
      @changes = {}.with_indifferent_access
      @source_kind = source.solution_kind
      @target_kind = target.solution_kind

      super
    end

    wrapped_hook! def extract
      @source_attributes = yield source.extract_attributes
      @target_attributes = yield target.extract_attributes

      super
    end

    wrapped_hook! def compare
      SolutionInterface::TO_CLONE.each do |key|
        source_value = source_attributes[key]
        target_value = target_attributes[key]

        changes[key] = [source_value, target_value] unless values_match?(key, source_value, target_value)
      end

      super
    end

    # @return [Boolean] true if value is the same
    def values_match?(key, source_value, target_value)
      case key
      when *SolutionInterface::ATTACHMENTS
        source_value&.sha256 == target_value&.sha256
      when *SolutionInterface::TAG_LISTS
        source_value.sort == target_value.sort
      else
        source_value == target_value
      end
    end
  end
end
