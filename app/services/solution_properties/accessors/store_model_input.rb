# frozen_string_literal: true

module SolutionProperties
  module Accessors
    # @note This is tied closely to {StoreModelList} and is never directly processed,
    #   but exists because each kind needs an associated accessor class.
    class StoreModelInput < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :store_model_input
    end
  end
end
