# frozen_string_literal: true

class SystemConfig < ApplicationConfig
  attr_config(
    client_ip_header: "do-connecting-ip",
    use_async_dataloader: true,
    validate_graphql_query: true
  )

  coerce_types(
    use_async_dataloader: :boolean,
    validate_graphql_query: :boolean
  )
end
