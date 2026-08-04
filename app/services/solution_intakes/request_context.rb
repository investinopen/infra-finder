# frozen_string_literal: true

module SolutionIntakes
  class RequestContext
    include Dry::Monads[:result]
    include Dry::Initializer[undefined: false].define -> do
      option :skip_validations, Types::InputBool, default: proc { false }
      option :solution_intake, Types::IntakeParams, as: :params, default: proc { Dry::Core::Constants::EMPTY_HASH }
    end

    INTAKE_PARAMS = ::SolutionIntake.build_strong_params.freeze

    # @return [Boolean]
    attr_reader :apply_editor_validations

    alias apply_editor_validations? apply_editor_validations

    # An enum that determines how the update should behave.
    #
    # * `:draft` - The update is a draft and should skip validations.
    # * `:submit` - The update is a submission and should apply validations, and transition the state
    #   to `:in_review` if the solution intake is currently in the `:pending` state.
    # @return [:draft, :submit]
    attr_reader :mode

    alias skip_validations? skip_validations

    def initialize(...)
      super

      @mode = skip_validations? ? :draft : :submit

      @apply_editor_validations = submit?
    end

    # @param [SolutionIntake] solution_intake
    # @return [void]
    def assign_to!(solution_intake)
      solution_intake.assign_attributes(params)
      solution_intake.apply_editor_validations = apply_editor_validations?
    end

    # Whether we are in `draft` {#mode}.
    def draft? = mode == :draft

    # Whether we are in `submit` {#mode}.
    def submit? = mode == :submit

    # @param [SolutionIntake] solution_intake
    # @return [(Boolean, Symbol)]
    def update!(solution_intake)
      assign_to!(solution_intake)

      saved = solution_intake.save

      if saved
        if submit? && solution_intake.in_state?(:pending)
          solution_intake.transition_to!(:in_review)
        end

        Success mode
      else
        Failure mode
      end
    end

    class << self
      # @param [ActionController::Parameters] params
      # @return [SolutionIntakes::RequestContext]
      def from(params)
        skip_validations = params[:skip_validations].presence

        solution_intake = extract_strong(params)

        new(solution_intake:, skip_validations:)
      end

      private

      # @param [ActionController::Parameters] params
      # @return [Hash]
      def extract_strong(params)
        params.require(:solution_intake).permit(*INTAKE_PARAMS).to_h
      rescue ActionController::ParameterMissing
        Dry::Core::Constants::EMPTY_HASH
      end
    end
  end
end
