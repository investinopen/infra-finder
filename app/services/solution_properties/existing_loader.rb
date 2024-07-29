# frozen_string_literal: true

module SolutionProperties
  class ExistingLoader < Support::HookBased::Actor
    include SolutionProperties::Constants

    include Dry::Initializer[undefined: false].define -> do
      option :output_path, Types.Instance(::Pathname), default: proc { DEFAULT_OUTPUT_PATH }
    end

    standard_execution!

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :mapping

    # @return [Dry::Monads::Success(ActiveSupport::HashWithIndifferentAccess { String => Hash })]
    def call
      run_callbacks :execute do
        yield prepare!

        yield load!
      end

      Success mapping
    end

    wrapped_hook! def prepare
      @mapping = {}.with_indifferent_access

      super
    end

    wrapped_hook! def load
      existing = YAML.load_file output_path, aliases: true, symbolize_names: true

      existing.each_with_object(mapping) do |record, map|
        record => { name:, }

        map[name] = record
      rescue NoMatchingPatternKeyError
        # :nocov:
        next
        # :nocov:
      end

      super
    rescue Errno::ENOENT
      super
    end
  end
end
