# frozen_string_literal: true

class HostingStrategy < ApplicationRecord
  include HasVisibility
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!

  legacy_import_source_key :can_infra_hosted_by_service_prvdr_or_3rd_party_id
end
