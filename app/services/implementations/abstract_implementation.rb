# frozen_string_literal: true

module Implementations
  # @abstract
  class AbstractImplementation
    extend Dry::Core::ClassAttributes

    include Support::EnhancedStoreModel

    defines :implementation_name, type: Solutions::Types::Symbol.optional

    defines :link_mode, type: Solutions::Types::ImplementationLinkMode

    link_mode :none

    delegate :has_any_links?,
      :has_many_links?,
      :has_single_link?,
      :has_no_links?,
      :has_statement?,
      :linked?,
      :unlinked?,
      to: :class

    def available?
      parent.try(:"#{implementation_name}_available?")
    end

    def in_progress?
      parent.try(:"#{implementation_name}_in_progress?")
    end

    # @api private
    # @return [Symbol]
    def implementation_name
      self.class.implementation_name
    end

    # @return [Solutions::Types::ImplementationLinkMode]
    def link_mode
      self.class.link_mode
    end

    def requires_populated_link?
      false
    end

    def read_url
      case link_mode
      when :many
        links.try(:first).try(:url)
      when :single
        # :nocov:
        link.try(:url)
        # :nocov:
      else
        # :nocov:
        raise "no link for #{implementation_name}"
        # :nocov:
      end
    end

    # @param [String] new_value
    def write_url(new_value)
      case link_mode
      when :many
        if links.empty?
          self.links = [Implementations::Link.new(url: new_value)]
        else
          links.first.url = new_value
        end
      when :single
        # :nocov:
        link.url = new_value
        # :nocov:
      else
        # :nocov:
        raise "no link for #{implementation_name}"
        # :nocov:
      end
    end

    # @param ["links", "statement"] property_name
    # @return [String, nil]
    def read_csv_property(property_name)
      case property_name
      when "links", "link"
        read_url
      when "statement"
        statement
      else
        # :nocov:
        raise "unknown property: #{property_name.inspect}"
        # :nocov:
      end
    end

    # @param ["links", "statement"] property_name
    # @param [String] new_value
    # @return [String, nil]
    def write_csv_property(property_name, new_value)
      case property_name
      when "links", "link"
        write_url(new_value)
      when "statement"
        self.statement = new_value
      else
        # :nocov:
        raise "unknown property: #{property_name.inspect}"
        # :nocov:
      end
    end

    # @return [String]
    def to_csv
      as_json.transform_values do |value|
        cast_to_csv(value)
      end.compact.to_json
    end

    private

    def cast_to_csv(value)
      case value
      when Array
        value.map { cast_to_csv(_1) }.compact_blank
      when Hash
        value.transform_values { cast_to_csv(_1) }.compact
      when false then value
      else
        value.presence
      end
    end

    class << self
      def derive_implementation_name
        name.demodulize.underscore
      end

      def inherited(subclass)
        super if defined?(super)

        subclass.implementation_name subclass.derive_implementation_name.to_sym
      end

      def has_any_links?
        link_mode != :none
      end

      alias linked? has_any_links?

      def has_many_links?
        link_mode == :many
      end

      def has_no_links?
        link_mode == :none
      end

      alias unlinked? has_no_links?

      def has_single_link?
        link_mode == :single
      end

      def has_statement?
        self < Implementations::WithStatement
      end

      # @return [Array]
      def strong_params
        attribute_names.without("link", "links").map(&:to_sym).tap do |arr|
          case link_mode
          in :many
            arr << { links_attributes: %i[url label] }
          in :single
            arr << { link: %i[url label] }
          else
            # :nocov:
            arr.dup
            # :nocov:
          end
        end
      end

      # @return [void]
      def with_link!
        include Implementations::WithLink
      end

      # @return [void]
      def with_links!
        include Implementations::WithLinks
      end

      def with_statement!
        include Implementations::WithStatement
      end
    end
  end
end
