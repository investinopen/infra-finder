# frozen_string_literal: true

module Solutions
  class ImplementationDetail < Support::FlexibleStruct
    attribute :name, Types::Symbol
    attribute :type, Types::Class
    attribute :enum, Types::Symbol
  end
end
