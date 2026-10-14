# frozen_string_literal: true

module EncodedSets
  # @see ::Filtering::Inputs::TimeMatch
  class TimeMatch
    include Support::EnhancedStoreModel
    include Support::GQL::ExposesType

    expose_graphql! ::Types::FilterMatchTimeType

    attribute :eq, :datetime
    attribute :lt, :datetime
    attribute :lteq, :datetime
    attribute :gt, :datetime
    attribute :gteq, :datetime
    attribute :not_eq, :datetime
  end
end
