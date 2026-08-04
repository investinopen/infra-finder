# frozen_string_literal: true

module Utility
  class StrongParamSet
    include Enumerable

    alias to_ary to_a

    # @return [Integer]
    attr_reader :depth

    # @return [:unset, :array, :mixed, :simple, :mapping]
    attr_reader :mode

    # @return [Boolean]
    attr_reader :nested

    alias nested? nested

    # @return [Integer]
    attr_reader :size

    def initialize(depth: 0)
      @list = SortedSet.new
      @map_keys = SortedSet.new
      @map = {}.with_indifferent_access
      @mode = :unset
      @size = 0

      @depth = depth
      @nested = depth.positive?
    end

    def <<(input)
      allow! input

      return self
    end

    # @param [Symbol, String] key
    # @param [Utility::StrongParamSet]
    def [](key)
      array!(key) unless has_mapped?(key)

      @map.fetch(key)
    end

    def []=(key, value)
      allow!({ key => value })
    end

    # @param [Symbol, String] key
    # @return [Utility::StrongParamSet]
    def array!(key)
      self[key] = Dry::Core::Constants::EMPTY_ARRAY

      return self
    end

    # @return [Utility::StrongParamSet]
    def clear
      @list.clear
      @map.clear
      @map_keys.clear

      recalculate!

      return self
    end

    # @param [Array] enum
    def concat(input)
      Array(input).each do |item|
        allow! item
      end

      return self
    end

    # @param [Symbol, String] key
    # @return [:simple, :mapped, nil]
    def delete(key)
      case key
      in Symbol if has_simple?(key)
        @list.delete(key)

        recalculate!

        return :simple
      in Symbol if has_mapped?(key)
        @map.delete(key)
        @map_keys.delete(key)

        recalculate!

        return :mapped
      in Symbol
        return nil
      in String
        delete(key.to_sym)
      else
        raise ArgumentError, "Unsupported key type: #{key.class}"
      end

      return nil
    end

    def each
      return enum_for(:each) unless block_given?

      @list.each { |item| yield item }

      yield export_map if @map.any?
    end

    def empty? = @size.zero?

    def has_mapped?(key)
      case key
      when Symbol, String
        @map.key?(key)
      else
        raise ArgumentError, "Unsupported key type: #{key.class}"
      end
    end

    def param?(key)
      has_simple?(key) || has_mapped?(key)
    end

    alias key? param?
    alias has_key? param?
    alias has_param? param?

    # @param [Symbol, String] key
    def has_simple?(key)
      case key
      when Symbol
        key.in?(@list)
      when String
        key.to_sym.in?(@list)
      else
        raise ArgumentError, "Unsupported key type: #{key.class}"
      end
    end

    # @!group Modes

    def array? = @mode == :array

    def mapping? = @mode == :mapping

    def mixed? = @mode == :mixed

    def simple? = @mode == :simple

    def unset? = @mode == :unset

    # @!endgroup

    protected

    # @param [Symbol, String, Hash, Array] input
    # @return [void]
    def allow!(input)
      case input
      when Symbol, String
        allow_simple! input.to_sym
      when Hash
        input.each do |key, value|
          case key
          when Symbol, String
            allow_mapped!(key.to_sym, value)
          else
            raise ArgumentError, "Unsupported key type: #{key.class}"
          end
        end
      when Array, Enumerable
        input.each { |item| allow!(item) }
      else
        raise ArgumentError, "Unsupported input type: #{input.class}"
      end

      recalculate!
    end

    # @return [Array<Symbol, Hash>]
    # @return [Hash{ Symbol => Object }]
    def export_nested
      if mapping?
        export_map
      else
        to_a
      end
    end

    private

    # @return [:unset, :array, :mixed, :simple, :mapping]
    def detect_mode
      if @list.empty? && @map.empty?
        nested? ? :array : :unset
      elsif @list.any? && @map.any?
        :mixed
      elsif @list.any?
        :simple
      elsif @map.any?
        :mapping
      else
        # :nocov:
        raise "Impossible state: list: #{@list.inspect}, map: #{@map.inspect}"
        # :nocov:
      end
    end

    # @return [void]
    def recalculate!
      @mode = detect_mode
      @size = @list.size + @map.size
    end

    # @param [Symbol] key
    # @param [Symbol, String, Hash, Array] value
    # @return [void]
    def allow_mapped!(key, value)
      @list.delete(key) if has_simple?(key)

      @map_keys << key

      @map[key] ||= Utility::StrongParamSet.new(depth: @depth + 1)

      @map[key].allow! value
    end

    # @param [Symbol] key
    # @return [void]
    def allow_simple!(key)
      @list << key unless has_mapped?(key)
    end

    # @return [Hash{ Symbol => Object }]
    def export_map
      @map_keys.each_with_object({}) do |key, hash|
        value = @map.fetch(key)

        hash[key] = value.export_nested
      end
    end
  end
end
