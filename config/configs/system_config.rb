# frozen_string_literal: true

class SystemConfig < ApplicationConfig
  attr_config(
    validate_graphql_query: true
  )

  coerce_types(
    validate_graphql_query: :boolean
  )
end
