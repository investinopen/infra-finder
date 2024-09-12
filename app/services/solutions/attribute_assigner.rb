# frozen_string_literal: true

module Solutions
  class AttributeAssigner < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :source, Types::AnySolution
      param :target, Types::AnySolution
    end

    standard_execution!

    # @return [Solution]
    attr_reader :actual

    # @return [SolutionDraft]
    attr_reader :draft

    # @return [:apply_draft, :populate_draft]
    attr_reader :action

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :attributes

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :source_attributes

    # @return [Solutions::Types::Kind]
    attr_reader :source_kind

    # @return [Solutions::Types::Kind]
    attr_reader :target_kind

    delegate :draft_overrides, to: :draft, allow_nil: true

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield validate!

        yield extract!

        yield assign!
      end

      Success()
    end

    wrapped_hook! def prepare
      @source_kind = source.solution_kind
      @target_kind = target.solution_kind

      @action = yield derive_assignment_action

      super
    end

    wrapped_hook! def validate
      # :nocov:
      return Failure[:mismatched_solution_draft, actual, draft] if actual != draft.solution
      # :nocov:

      super
    end

    wrapped_hook! def extract
      @source_attributes = yield source.extract_attributes

      @attributes = yield filter_attributes_by_action

      super
    end

    wrapped_hook! def assign
      attributes.each do |attribute, value|
        prop = SolutionProperty.find attribute.to_s

        if prop.assign_method == :write_attribute
          target.write_attribute attribute, value
        else
          # Associations, attachments, tag lists, etc
          target.__send__(:"#{attribute}=", value)
        end
      rescue FrozenRecord::RecordNotFound
        # Associations, attachments, tag lists, etc
        target.__send__(:"#{attribute}=", value)
      end

      Solutions::Validations.skip_editor_validations! do
        target.save!
      end

      super
    end

    private

    # @return [Dry::Monads::Success(ActiveSupport::HashWithIndifferentAccess)]
    def filter_attributes_by_action
      case action
      in :apply_draft
        Success source_attributes.slice(*draft_overrides)
      in :populate_draft
        Success source_attributes.without(*draft_overrides)
      end
    end

    # @return [Symbol]
    def derive_assignment_action
      if source_kind == :actual && target_kind == :draft
        @actual = source
        @draft = target

        Success :populate_draft
      elsif source_kind == :draft && target_kind == :actual
        @actual = target
        @draft = source

        Success :apply_draft
      else
        # :nocov:
        Failure[:invalid_solution_assignment, [source_kind, target_kind]]
        # :nocov:
      end
    end
  end
end
