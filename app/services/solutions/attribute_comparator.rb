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
      @key = @prop = @vocab = nil
      @vocab = nil

      super
    end

    wrapped_hook! def extract
      @source_attributes = yield source.extract_attributes
      @target_attributes = yield target.extract_attributes

      super
    end

    wrapped_hook! def compare
      SolutionProperty.to_clone.each do |key|
        @key = key
        @prop = SolutionProperty.find(key.to_s)
        @vocab = @prop.vocab

        source_value = source_attributes[key]
        target_value = target_attributes[key]

        changes[key] = [source_value, target_value] unless values_match?(source_value, target_value)
      ensure
        @key = @prop = @vocab = nil
      end

      super
    end

    def find_term(value)
      case value
      when ControlledVocabularyRecord
        find_term value.term
      else
        @vocab.find_term(value).value_or(nil)
      end
    end

    def compare_nested(value)
      case value
      when Array
        value.map { compare_nested _1 }
      when Hash
        value.transform_values { compare_nested _1 }
      when StoreModel::Model
        compare_nested value.as_json
      else
        value.presence
      end
    end

    def to_compare(raw_value)
      case @prop.kind
      when :attachment
        raw_value&.sha256
      when :boolean
        raw_value
      when :multi_option
        Array(raw_value).map { find_term(_1) }.compact.sort
      when :single_option
        find_term(raw_value)
      else
        compare_nested raw_value
      end
    end

    # @return [Boolean] true if value is the same
    def values_match?(source_value, target_value)
      compare_source = to_compare source_value
      compare_target = to_compare target_value

      compare_source == compare_target
    end
  end
end
