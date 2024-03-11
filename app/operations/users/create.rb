# frozen_string_literal: true

module Users
  # Wrap around the creation process.
  #
  # @see Users::Creator
  class Create < Support::SimpleServiceOperation
    service_klass Users::Creator
  end
end
