# frozen_string_literal: true

module Implementations
  # @abstract
  class AbstractImplementation
    extend Dry::Core::ClassAttributes

    include Support::EnhancedStoreModel
    include Structured::CSVConversion

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

    def available? = parent.try(:"#{implementation_name}_available?")

    def available_with_url? = available? && has_url?

    def has_url? = link_mode != :none && read_url.present?

    def in_progress? = parent.try(:"#{implementation_name}_in_progress?")

    # @api private
    # @return [Symbol]
    def implementation_name = self.class.implementation_name

    # @return [Solutions::Types::ImplementationLinkMode]
    def link_mode = self.class.link_mode

    def requires_populated_link? = false

    # @api private
    # @return [String]
    def read_url
      case link_mode
      when :many
        links.try(:first).try(:url)
      when :single
        link.try(:url)
      else
        # :nocov:
        raise "no link for #{implementation_name}"
        # :nocov:
      end
    end

    # @param [String] new_value
    # @return [void]
    def write_url(new_value)
      urls = new_value.present? ? URI.extract(new_value).map { _1.chomp(?,) } : []

      case link_mode
      when :many
        if links.empty?
          self.links = urls.map { |url| Implementations::Link.new(url:) }
        else
          urls.each_with_index do |url, index|
            links[index].url = url
          end
        end
      when :single
        # :nocov:
        link.url = urls.first
        # :nocov:
      else
        # :nocov:
        raise "no link for #{implementation_name}"
        # :nocov:
      end
    end

    # @param ["link", "links", "statement"] property_name
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

    # @param ["link", "links", "statement"] property_name
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

    class << self
      def has_any_links? = link_mode != :none

      alias linked? has_any_links?

      def has_many_links? = link_mode == :many

      def has_no_links? = link_mode == :none

      alias unlinked? has_no_links?

      def has_single_link? = link_mode == :single

      def has_statement? = self < Implementations::WithStatement

      # @return [void]
      def with_link!
        include Implementations::WithLink
      end

      # @return [void]
      def with_links!
        include Implementations::WithLinks
      end

      # @return [void]
      def with_statement!
        include Implementations::WithStatement
      end

      protected

      def derive_implementation_name = name.demodulize.underscore.to_sym

      # @return [void]
      def derive_implementation_name!
        implementation_name derive_implementation_name
      end

      # @param [Class<AbstractImplementation>] subclass
      # @return [void]
      def inherited(subclass)
        super if defined?(super)

        subclass.derive_implementation_name!
      end
    end
  end
end
