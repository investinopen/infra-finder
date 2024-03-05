# frozen_string_literal: true

# A concern for models which can be used as filters in the admin section
# as well as on the frontend.
module Filterable
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :filter_collection_order_scope, type: Dry::Types["symbol"]

    filter_collection_order_scope :all
  end

  module ClassMethods
    # @return [Proc]
    def for_filter_collection
      klass = self

      proc do
        klass.filter_collection(user: current_user)
      end
    end

    # @param [User, nil] user
    # @return [ActiveRecord::Relation<Filterable>]
    def filter_collection(user: nil)
      ordered_for_filter_collection.scoped_for_filter_collection_for(user)
    end

    # @api private
    # @return [ActiveRecord::Relation<Filterable>]
    def ordered_for_filter_collection
      __send__(filter_collection_order_scope)
    end

    # @api private
    # @return [ActiveRecord::Relation<Filterable>]
    def scoped_for_filter_collection_for(user)
      Pundit.policy_scope!(user, all)
    end
  end
end
