# frozen_string_literal: true

module Solutions
  class OptionReplacer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :old_option, Types::Option
      param :new_option, Types::Option

      option :replacement, Types.Instance(OptionReplacement), default: proc { OptionReplacement.new(old_option:, new_option:) }
    end

    prepend TransactionalCall

    delegate :multiple_option?, :single_option?, to: :old_option

    standard_execution!

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield update_all_links! if multiple_option?

        yield update_all_references! if single_option?

        yield remove_old_option!
      end

      Success()
    end

    wrapped_hook! def prepare
      return Failure[:invalid, replacement] unless replacement.valid?

      super
    end

    wrapped_hook! def update_all_links
      yield update_links_for! kind: :actual
      yield update_links_for! kind: :draft

      super
    end

    wrapped_hook! def update_all_references
      yield update_references_for! kind: :actual
      yield update_references_for! kind: :draft

      super
    end

    wrapped_hook! def remove_old_option
      old_option.destroy!

      new_option.refresh_counters!

      super
    end

    private

    # @param [:actual, :draft] kind
    # @return [(<String>, :symbol)]
    def ids_for(kind)
      case kind
      in :actual
        [old_option.solution_ids, :solution_id]
      in :draft
        [old_option.solution_drafts.mutable.ids, :solution_draft_id]
      else
        # :nocov:
        raise "invalid solution kind: #{kind.inspect}"
        # :nocov:
      end
    end

    # @param [:actual, :draft] kind
    # @return [Dry::Monads::Success]
    def update_links_for!(kind:)
      assoc = new_option.link_association_for kind

      ids, sol_key = ids_for(kind)

      return Success() if ids.blank?

      option_key = assoc.foreign_key.to_sym

      base = { option_key => new_option.id }

      tuples = ids.map do |id|
        base.merge(sol_key => id)
      end

      unique_by = [sol_key, option_key]

      assoc.klass.upsert_all(tuples, unique_by:)

      Success()
    end

    # @param [:actual, :draft] kind
    # @return [Dry::Monads::Success]
    def update_references_for!(kind:)
      ids, = ids_for(kind)

      option_key = new_option.foreign_key_for(kind)

      klass = new_option.association_for(kind).klass

      klass = klass.mutable if kind == :draft

      klass.where(id: ids).update_all(option_key => new_option.id)

      Success()
    end
  end
end
