# frozen_string_literal: true

module VOGTesting
  module Shapes
    class WithUser < Support::FlexibleStruct
      attribute? :user, VOGTesting::Types::Any
    end
  end
end
