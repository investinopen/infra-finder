# frozen_string_literal: true

module Events
  # @see Events::NormalizeParams
  class ParamsNormalizer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :input, Types::Hash
    end

    standard_execution!

    # Order here matters, as it is used to determine what values
    # in the `params` hash will be used to auto-populate the `record` key.
    #
    # @see .default_record_for
    RECORD_DERIVATION_KEYS = %i[
      solution_intake
      solution_draft
      solution
      provider
    ].freeze

    # @return [ApplicationRecord, nil]
    attr_reader :record

    # The output hash
    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :params

    # @return [Dry::Monads::Result]
    def call
      run_callbacks :execute do
        yield prepare!

        yield find_default_record!

        yield normalize_params!
      end

      Success params.symbolize_keys
    end

    wrapped_hook! def prepare
      @params = input.with_indifferent_access

      @record = nil

      super
    end

    wrapped_hook! def find_default_record
      params[:record] ||= derive_default_record

      return Failure[:missing_record] unless params[:record]

      super
    end

    wrapped_hook! def normalize_params
      RECORD_DERIVATION_KEYS.each do |key|
        handle!(params[key])
      end

      super
    end

    private

    # @return [ApplicationRecord, nil]
    def derive_default_record
      return params[:record] if params[:record]

      RECORD_DERIVATION_KEYS.each do |key|
        value = params[key]

        next unless value.present?

        return value
      end

      nil
    end

    def handle!(input)
      case input
      in ::SolutionIntake => intake
        handle_intake!(intake)
      in ::SolutionDraft => draft
        handle_draft!(draft)
      in ::Solution => solution
        handle_solution!(solution)
      in ::Provider => provider
        handle_provider!(provider)
      else
        # intentionally left blank
      end
    end

    # @param [SolutionDraft] draft
    # @return [void]
    def handle_draft!(draft)
      params[:solution_draft] ||= draft

      handle!(draft.solution)
    end

    # @param [SolutionIntake] intake
    # @return [void]
    def handle_intake!(intake)
      params[:solution_intake] ||= intake
      params[:solution_name] ||= intake.name

      handle!(intake.provider)
      handle!(intake.solution)
    end

    # @param [Provider] provider
    # @return [void]
    def handle_provider!(provider)
      params[:provider] ||= provider
    end

    # @param [Solution] solution
    # @return [void]
    def handle_solution!(solution)
      params[:solution] ||= solution
      params[:solution_name] ||= solution.name

      handle!(solution.provider)
    end
  end
end
