# frozen_string_literal: true

# A concern that better supports inheritance for ransackable facets on models.
module ExposesRansackable
  extend ActiveSupport::Concern

  ALLOWANCE_RANKING = {
    super_admin: 5,
    admin: 4,
    editor: 3,
    any: -10
  }.freeze

  # @api private
  RANSACKABLE_TYPES = %w[
    associations
    attributes
    scopes
  ].freeze

  included do
    extend Dry::Core::ClassAttributes

    defines :ransackable_accessors, type: Types::AccessorMap
    defines :ransackable_default_allowance, type: Types::Allowance

    ransackable_default_allowance :any

    accessors = RANSACKABLE_TYPES.index_with do |type_name|
      RansackableAccessor.new(type_name)
    end

    ransackable_accessors accessors

    accessors.each_value do |mod|
      extend mod
    end

    expose_ransackable_attributes! :id, :created_at, :updated_at
  end

  module ClassMethods
    # @param [ExposesRansackable::Types::Allowance] allowance
    def ransackable_minimum_allowance!(allowance)
      ransackable_default_allowance allowance

      ransackable_accessors.each_value do |accessor|
        __send__(accessor.adjust_allowance, allowance)
      end
    end
  end

  module Types
    include Dry.Types

    Allowance = Types::Symbol.default(:any).enum(*ALLOWANCE_RANKING.keys)

    MethodName = Types::Symbol

    Name = Types::String.constrained(format: /\A[a-z]\w*?[a-z0-9]\z/)

    Ranking = Types::Integer.default(-10).enum(*ALLOWANCE_RANKING.values)

    Type = Types::String.enum(*RANSACKABLE_TYPES)

    AccessorMap = Types::Hash.map(Type, Types.Instance(Module))
  end

  class RankedAllowance < Support::FlexibleStruct
    extend Dry::Core::Cache

    include Comparable
    include Dry::Core::Equalizer.new(:name)

    attribute :name, Types::Allowance
    attribute :ranking, Types::Ranking

    def <=>(other)
      # :nocov:
      return super unless other.kind_of?(self.class)
      # :nocov:

      [ranking] <=> [other.ranking]
    end

    class << self
      # @param [Symbol] name
      # @return [RankedAllowance]
      def from(name)
        name = Types::Allowance[name]

        fetch_or_store(:from, name) do
          ranking = ALLOWANCE_RANKING.fetch(name)

          new(name:, ranking:)
        end
      end

      def new(input, ...)
        case input
        when Symbol
          from(input)
        else
          super
        end
      end
    end
  end

  class ExposedValue < Support::FlexibleStruct
    include Comparable
    include Dry::Core::Equalizer.new(:name)
    include Support::Typing

    attribute :name, Types::Name
    attribute :allowance, RankedAllowance

    def <=>(other)
      # :nocov:
      return super unless other.kind_of?(self.class)
      # :nocov:

      [name] <=> [other.name]
    end

    # @param [ExposesRansackable::RankedAllowance] new_allowance
    # @return [ExposesRansackable::ExposedValue]
    def constrain_to(new_allowance)
      allowance >= new_allowance ? self : self.class.new(name:, allowance: new_allowance)
    end

    # @param [ExposesRansackable::RankedAllowance] current_allowance
    def exposed_for?(current_allowance)
      allowance <= current_allowance
    end
  end

  class ExposedValues
    include Dry::Core::Memoizable

    include Dry::Initializer[undefined: false].define -> do
      param :values, ExposedValue::List, default: proc { [].freeze }

      option :default_allowance, Types::Allowance, default: proc { :any }
      option :type_name, Types::Name
    end

    include Support::Typing

    # @param [<#to_s>] new_values
    # @param [ExposesRansackable::Types::Allowance] on
    # @return [ExposesRansackable::ExposedValues] a new instance
    def add(*new_values, on: default_allowance)
      allowance = RankedAllowance.from(on)

      normalized = new_values.flatten.map { normalize _1, allowance: }

      new_instance_with (normalized | values).sort.freeze
    end

    # @param [ExposesRansackable::Types::Allowance] minimum_allowance
    # @return [ExposesRansackable::ExposedValue] a new instance
    def adjust_minimum_allowance(minimum_allowance)
      allowance = RankedAllowance.from(minimum_allowance)

      new_values = values.map { _1.constrain_to(allowance) }

      new_instance_with(new_values, default_allowance: minimum_allowance)
    end

    # @return [ExposesRansackable::ExposedValues] a new instance
    def clear
      new_instance_with [].freeze
    end

    # Caches the associations / attributes / scopes for the given auth_object's allowance.
    #
    # @param [ActiveAdmin::PunditAdapter, Symbol, User, nil]
    # @return [<String>]
    def values_for(auth_object = nil)
      allowance = ranked_allowance_from(auth_object)

      values_for_allowance allowance
    end

    private

    # @return [<String>]
    memoize def values_for_allowance(allowance)
      values.each_with_object([]) do |value, out|
        out << value.name if value.exposed_for?(allowance)
      end
    end

    # @param [ActiveAdmin::PunditAdapter, Symbol, User, nil]
    # @return [ExposesRansackable::Types::Allowance]
    def allowance_from(auth_object = nil)
      case auth_object
      when ActiveAdmin::PunditAdapter
        allowance_from(auth_object.user)
      when Types::Allowance
        auth_object
      when User
        auth_object.ransackable_allowance
      else
        :any
      end
    end

    # @return [ExposesRansackable::ExposedValues] a new instance
    def new_instance_with(values, **new_options)
      self.class.new(values, default_allowance:, type_name:, **new_options)
    end

    # @param [#to_s] name
    # @param [ExposesRansackable::RankedAllowance]
    def normalize(name, allowance:)
      case name
      when String
        ExposesRansackable::ExposedValue.new(name:, allowance:)
      when Symbol
        normalize(name.to_s, allowance:)
      else
        # :nocov:
        raise TypeError, "cannot normalize for ransackable value: #{name.inspect}"
        # :nocov:
      end
    end

    def ranked_allowance_from(auth_object = nil)
      name = allowance_from auth_object

      RankedAllowance.from(name)
    end
  end

  # @api private
  class RansackableAccessor < Module
    include Dry::Initializer[undefined: false].define -> do
      param :type_name, Types::Type

      option :adjust_allowance, Types::MethodName, default: proc { :"adjust_minimum_allowance_for_#{type_name}!" }
      option :clear_exposed, Types::MethodName, default: proc { :"clear_exposed_ransackable_#{type_name}!" }
      option :exposed_attr, Types::MethodName, default: proc { :"exposed_ransackable_#{type_name}" }
      option :exposer, Types::MethodName, default: proc { :"expose_ransackable_#{type_name}!" }
      option :ransackable_method, Types::MethodName, default: proc { :"ransackable_#{type_name}" }
    end

    def initialize(...)
      super

      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{adjust_allowance}(...)
        #{exposed_attr} #{exposed_attr}.adjust_minimum_allowance(...)

        return
      end

      def #{clear_exposed}
        #{exposed_attr} #{exposed_attr}.clear

        return
      end

      def #{exposer}(...)
        #{exposed_attr} #{exposed_attr}.add(...)

        return
      end

      def #{ransackable_method}(auth_object = nil)
        #{exposed_attr}.values_for(auth_object)
      end
      RUBY
    end

    def extended(base)
      base.defines exposed_attr, type: ExposedValues::Type

      base.__send__(exposed_attr, ExposedValues.new([], type_name:))
    end
  end
end
