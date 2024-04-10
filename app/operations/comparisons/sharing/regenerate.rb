# frozen_string_literal: true

module Comparisons
  module Sharing
    # @see Comparisons::Sharing::Regenerator
    class Regenerate < Support::SimpleServiceOperation
      service_klass Comparisons::Sharing::Regenerator
    end
  end
end
