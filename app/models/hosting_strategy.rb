# frozen_string_literal: true

class HostingStrategy < ApplicationRecord
  include HasVisibility
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!
end
