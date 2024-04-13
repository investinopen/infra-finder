# frozen_string_literal: true

module OpenGraph
  class Properties < Support::WritableStruct
    extend ActiveModel::Callbacks

    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    attribute :title, Types::Title
    attribute :type, Types::Type
    attribute? :image, Types::URL.optional
    attribute? :url, Types::URL.optional
    attribute? :description, Types::String.optional

    strip_attributes

    validates :title, :type, :image, :url, :description, presence: true
  end
end
