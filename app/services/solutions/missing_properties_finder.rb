# frozen_string_literal: true

module Solutions
  # Find the required properties that a solution, draft, or intake has no value for.
  # This is the single definition of completeness: the `:complete` validations and
  # the cached `missing_properties` both come from it.
  #
  # @see Solutions::FindMissingProperties
  # @see SolutionProperty.with_presence_required_for
  class MissingPropertiesFinder < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :record, Types::AnySolution
    end

    standard_execution!

    # @return [<String>] attribute names
    attr_reader :missing

    # @return [Dry::Monads::Success(<String>)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield find_missing_properties!
      end

      Success missing
    end

    wrapped_hook! def prepare
      @missing = []

      super
    end

    wrapped_hook! def find_missing_properties
      SolutionProperty.with_presence_required_for(record.solution_kind).each do |prop|
        next if prop.accepts_other? && record.public_send(:"#{prop.free_input_name}?")

        @missing << prop.attribute_name if blank?(prop.attribute_name)
      end

      record.additional_required_attributes.each do |attribute|
        @missing << attribute.to_s if blank?(attribute)
      end

      super
    end

    private

    # Matches the `presence` validator's notion of blank.
    #
    # @param [#to_sym] attribute
    def blank?(attribute)
      record.read_attribute_for_validation(attribute.to_sym).blank?
    end
  end
end
