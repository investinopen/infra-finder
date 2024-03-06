# frozen_string_literal: true

module StoredMessages
  # An individual message in a model's stored listing.
  class Message
    include Support::EnhancedStoreModel
    include Comparable

    actual_enum :l, :debug, :info, :warn, :error, :fatal, :unknown, default: proc { :debug }
    attribute :at, :datetime, default: proc { Time.current }
    attribute :m, :string
    attribute :s, :string
    attribute :t, :string_array
    attribute :q, :integer, default: proc { 0 }

    alias_attribute :level, :l
    alias_attribute :message, :m
    alias_attribute :step, :s
    alias_attribute :progname, :s
    alias_attribute :sequence, :q
    alias_attribute :tags, :t

    validates :l, :t, :m, presence: true

    # @param [StoredMessages::Message] other
    # @return [-1, 0, 1]
    def <=>(other)
      other.sort_tuple <=> sort_tuple
    end

    protected

    # @return [(Time, Integer)]
    def sort_tuple
      [at, sequence]
    end
  end
end
