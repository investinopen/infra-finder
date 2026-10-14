# frozen_string_literal: true

module EncodedSets
  class Collection
    include EncodedSets::Assignment

    delegate :[], :[]=, :fetch, :dig, :key?, :keys, :values, :each, to: :@attrs

    def initialize
      @attrs = {}.with_indifferent_access
    end

    def as_json(...) = to_h

    def to_h = @attrs.to_h
  end
end
