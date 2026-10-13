# frozen_string_literal: true

class SystemConfig < ApplicationConfig
  attr_config(
    client_ip_header: "do-connecting-ip",
    validate_graphql_query: true
  )

  coerce_types(
    validate_graphql_query: :boolean
  )
end
