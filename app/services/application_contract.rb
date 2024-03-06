# frozen_string_literal: true

# @abstract
class ApplicationContract < Dry::Validation::Contract
  import_predicates_as_macros
end
