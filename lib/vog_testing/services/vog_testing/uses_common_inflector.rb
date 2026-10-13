# frozen_string_literal: true

module VOGTesting
  module UsesCommonInflector
    extend ActiveSupport::Concern

    def inflector
      Common::Container[:inflector]
    end
  end
end
