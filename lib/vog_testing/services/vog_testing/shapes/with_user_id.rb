# frozen_string_literal: true

module VOGTesting
  module Shapes
    class WithUserId < Support::FlexibleStruct
      attribute? :user_id, VOGTesting::Types::String.optional
    end
  end
end
