# frozen_string_literal: true

module VOGMutations
  # The base contract class used by VOG mutations.
  #
  # Implementations of these contracts should live in {Mutations::Contracts}.
  #
  # @abstract
  class Contract < ApplicationContract
    extend Dry::Core::ClassAttributes

    include ::Support::Requests::ReadsCurrentUser

    # A pattern for deriving {#model_klass} and {#contract_verb} from the class name.
    DEFAULT_NAMING_PATTERN = /\A(?<model_name>\S+)(?<verb>Create|Update|Destroy|Mutate)\z/

    # @!attribute [r] model_klass
    # The model class that this contract is for.
    # @!scope class
    # @return [Class, nil]
    defines :model_klass, type: Support::Models::Types::ModelClass.optional

    model_klass nil

    # @!attribute [r] contract_verb
    # The verb that describes the mutation action.
    # @!scope class
    # @see VOGMutations::Types::ContractVerb
    # @return [:create, :update, :destroy, :mutate]
    defines :contract_verb, type: VOGMutations::Types::ContractVerb

    contract_verb :mutate

    # @!attribute [r] model_key
    # The i18n key for the model being mutated.
    # @!scope class
    # @return [Symbol, nil]
    defines :model_key, type: VOGMutations::Types::Symbol.optional

    model_key nil

    delegate :contract_verb, :model_key, to: :class

    # @raise [RuntimeError] if no model class is set
    def model_klass
      self.class.model_klass or raise "Must have set model_klass for contract"
    end

    # Whether this contract is for an update verb.
    def update_contract? = contract_verb == :update

    register_macro :check_protected_dependents do
      base.failure(:must_remove_or_reassign_dependents) if value.has_protected_dependents?
    end

    register_macro :unique_identifier do
      except = values[model_key]

      key.failure(:must_be_unique) if model_klass.has_existing_identifier?(value, except:)
    end

    class << self
      # @api private
      # Called when a subclass is created.
      #
      # It will {.derive_defaults_from_name!} on the subclass.
      # @param [Class] subclass
      # @return [void]
      def inherited(subklass)
        # simplecov:disable
        super if defined?(super)
        # simplecov:enable

        subklass.derive_defaults_from_name!
      end

      protected

      # This gets called during subclassing to derive defaults from the class name.
      # Something like `UserCreate` would set the {.model_klass} to {User} and the {.contract_verb} to `:create`.
      #
      # @see model!
      # @see DEFAULT_NAMING_PATTERN
      # @return [void]
      def derive_defaults_from_name!
        case name.demodulize
        when DEFAULT_NAMING_PATTERN
          contract_verb Regexp.last_match[:verb].downcase.to_sym

          # infra-finder: names like `ControlledVocabularyRecord` resolve to a concern, not a model.
          model! Regexp.last_match[:model_name].safe_constantize.then { _1 if _1.is_a?(Class) }
        else
          # simplecov:disable
          contract_verb :mutate
          # simplecov:enable
        end
      end

      # Sets the {.model_klass} and {.model_key} based on the given class
      #
      # @param [Class(ApplicationRecord)] klass
      # @return [void]
      def model!(klass)
        model_klass klass

        # simplecov:disable
        model_key klass&.model_name&.i18n_key
        # simplecov:enable
      end
    end
  end
end
