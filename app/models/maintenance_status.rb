# frozen_string_literal: true

class MaintenanceStatus < ApplicationRecord
  include HasVisibility
  include SeededOption
  include SolutionOption
  include TimestampScopes

  scalar!
end
