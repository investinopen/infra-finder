# frozen_string_literal: true

# A record that has a numeric, auto-incrementing identifier column.
module HasAutoincrementingIdentifier
  extend ActiveSupport::Concern

  included do
    attr_readonly :identifier

    after_commit :reload, on: :create
  end

  # @return [String]
  def display_name
    # :nocov:
    if new_record?
      "New #{model_name.human}"
    else
      "#{model_name.human} ##{identifier}"
    end
    # :nocov:
  end

  class_methods do
    # @param [Integer] identifier
    # @return [HasAutoincrementingIdentifier]
    def by_identifier!(identifier)
      find_by!(identifier:)
    end
  end
end
