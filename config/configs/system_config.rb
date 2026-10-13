# frozen_string_literal: true

class SystemConfig < ApplicationConfig
  attr_config(
    use_async_dataloader: true,
    validate_graphql_query: true
  )

  coerce_types(
    use_async_dataloader: :boolean,
    validate_graphql_query: :boolean
  )
end
