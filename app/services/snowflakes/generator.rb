# frozen_string_literal: true

module Snowflakes
  # @see Snowflakes::Generate
  class Generator < Support::FlexibleStruct
    include Snowflakes::Constants

    attribute :datacenter_id, Snowflakes::Types::DatacenterID
    attribute :worker_id, Snowflakes::Types::WorkerID

    # @return [Integer]
    attr_reader :last_timestamp

    # @return [Integer]
    attr_reader :sequence

    def initialize(...)
      super

      @last_timestamp = -1
      @sequence = 0
    end

    # @return [Integer]
    def call
      MUTEX_LOCK.synchronize do
        next_id
      end
    end

    private

    def next_id
      timestamp = now

      if timestamp < @last_timestamp
        raise "Clock moved backwards. Refusing to generate id for #{@last_timestamp - timestamp} milliseconds"
      end

      if @last_timestamp == timestamp
        @sequence = (@sequence + 1) & SEQUENCE_MASK

        if @sequence == 0
          timestamp = till_next_millis(@last_timestamp)
        end
      else
        @sequence = 0
      end

      @last_timestamp = timestamp

      [].tap do |a|
        a << ((timestamp - IOI_EPOCH) << TIMESTAMP_LEFT_SHIFT)
        a << (datacenter_id << DATACENTER_ID_SHIFT)
        a << (worker_id << WORKER_ID_SHIFT)
        a << @sequence
      end.reduce(:|)
    end

    def now = (::Time.current.to_f * 1000).to_i

    def till_next_millis(last_timestamp = @last_timestamp)
      # the scala version didn't have the sleep. Not sure if sleeping releases the mutex lock, more research required
      while (timestamp = now) < last_timestamp; sleep 0.0001; end

      timestamp
    end
  end
end
