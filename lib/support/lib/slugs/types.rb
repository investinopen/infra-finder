# frozen_string_literal: true

module Support
  module Slugs
    module Types
      extend Support::Typespace

      Slug = String.constrained(encoded_slug: true)
    end
  end
end
