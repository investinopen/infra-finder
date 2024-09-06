# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      # @abstract
      class BaseDiff
        extend Dry::Core::Cache

        include Support::EnhancedStoreModel
        include ActionView::Helpers::TagHelper

        COLORS = {
          change: "orange",
          set: "green",
          unset: "red"
        }.with_indifferent_access.freeze

        SIGILS = {
          change: ?~,
          set: ?+,
          unset: ?-,
        }.with_indifferent_access.freeze

        TYPE = Solutions::Revisions::AnyDiff.to_type

        enum :verb, in: { change: 0, set: 1, unset: 2 }

        attribute :name, :string

        attribute :old_value, :any_json
        attribute :new_value, :any_json

        def display_old_value
          display old_value unless set?
        end

        def display_new_value
          display new_value unless unset?
        end

        # @api private
        # @abstract
        def display(value)
          unless value.nil?
            describe(value)
          end
        end

        # @abstract
        # @api private
        def describe(value)
          value
        end

        def has_no_new_value?
          new_value.blank?
        end

        def label
          # :nocov:
          return unless name?
          # :nocov:

          fetch_or_store(name, :label) do
            SolutionProperty.find_by(name:).try(:field_label) || name.titleize
          end
        end

        # @return [Integer]
        def position
          SolutionProperty.field_ordering.fetch(name, 10_000)
        end

        def prune?
          set? && has_no_new_value?
        end

        # @!attribute [r] sigil
        # @return [String]
        def sigil
          SIGILS[verb]
        end

        # @!attribute [r] sigil
        # @return [String]
        def status_color
          COLORS[verb]
        end

        # @return [ActiveSupport::SafeBuffer]
        def status_tag(text, color: nil, **attrs)
          classes = attrs.delete(:class)

          attrs[:class] = ["status_tag", color, classes].flatten.compact.join(" ")

          content_tag(:span, text, **attrs)
        end

        def status_title
          ("%<verb>s property value" % { verb:, }).capitalize
        end

        class << self
          # @param [Hash] previous
          # @param [Hash] current
          # @return [<Solutions::Revisions::Diffs::BaseDiff>]
          def calculate(previous, current)
            prev = prepare_properties_for_comparison(previous)
            curr = prepare_properties_for_comparison(current)

            raw = Hashdiff.diff(prev, curr)

            raw.map { parse_hashdiff _1 }.reject(&:prune?).sort_by(&:position)
          end

          # @param [Symbol, ActiveModel::Types::Type]
          def diffs!(type, **options)
            attribute :old_value, type, **options
            attribute :new_value, type, **options
          end

          # @api private
          # @param [("~", String, Object, Object)] tuple
          # @param [("+", String, Object)]
          # @param [("-", String, Object)]
          # @return [Solutions::Revisions::Diffs::BaseDiff]
          def parse_hashdiff(tuple)
            case tuple
            in [?~, name, old_value, new_value]
              new(verb: :change, name:, old_value:, new_value:)
            in [?+, name, new_value]
              new(verb: :set, name:, new_value:)
            in [?-, name, old_value]
              new(verb: :unset, name:, old_value:)
            else
              # :nocov:
              raise "Unexpected hash diff tuple: #{tuple.inspect}"
              # :nocov:
            end.as_json.then { TYPE.cast_value(_1) }
          end

          private

          def prepare_properties_for_comparison(value)
            Hash(value).stringify_keys
          end
        end
      end
    end
  end
end
