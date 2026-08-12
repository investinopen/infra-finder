# frozen_string_literal: true

module Events
  # @see Events::ParamsNormalizer
  class NormalizeParams < Support::SimpleServiceOperation
    service_klass Events::ParamsNormalizer
  end
end
