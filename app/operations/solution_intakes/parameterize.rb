# frozen_string_literal: true

module SolutionIntakes
  class Parameterize < SolutionProperties::Transformer
    INTAKE_PARAMS = SolutionIntake.build_strong_params.freeze

    INTAKE_PARAM_NAMES = INTAKE_PARAMS.flat_map do |param_name|
      case param_name
      in String | Symbol
        param_name.to_sym
      in Hash
        param_name.keys.map(&:to_sym)
      else
        # :nocov:
        raise "Impossible: unexpected param_name type: #{param_name.class.name}"
        # :nocov:
      end
    end

    define! do
      indifferentize

      remap_associations

      remap_implementations

      remap_store_model_lists

      deep_symbolize_keys

      accept_keys INTAKE_PARAM_NAMES
    end
  end
end
