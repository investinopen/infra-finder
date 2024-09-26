# frozen_string_literal: true

module SolutionProperties
  module Admin
    # @see SolutionProperties::Admin::ParseTabs
    class TabParser < Support::HookBased::Actor
      include Dry::Monads[:validated, :list]
      include Dry::Initializer[undefined: false].define -> do
        option :admin_tabs_path, Support::GlobalTypes::Path, default: proc { ADMIN_TABS_PATH }
      end

      standard_execution!

      ADMIN_TABS_PATH = Rails.root.join("vendor", "admin-tabs.csv")

      # @return [{ String => <String> }]
      attr_reader :property_mapping

      # @return [{ String => <String> }]
      attr_reader :raw_tabs

      # @return [{ String => <SolutionProperties::Admin::PropertyWrapper> }]
      attr_reader :wrapped_properties

      # @return [<SolutionProperties::Admin::TabWrapper>]
      attr_reader :wrapped_tabs

      def call
        run_callbacks :execute do
          yield prepare!

          yield load_csv!

          yield load_wrapped_properties!

          yield check_for_duplicates_across_tabs!

          yield finalize!
        end

        Success wrapped_tabs
      end

      wrapped_hook! def prepare
        @property_mapping = Hash.new do |h, k|
          h[k] = []
        end

        @raw_tabs = Hash.new do |h, k|
          h[k] = []
        end

        @wrapped_properties = nil

        @wrapped_tabs = nil

        super
      end

      wrapped_hook! def load_csv
        csv = CSV.read(admin_tabs_path, headers: true)

        csv.each do |row|
          row.each do |tab, property|
            raw_tabs[tab] << property if property
          end
        end

        super
      end

      wrapped_hook! def load_wrapped_properties
        @wrapped_properties = raw_tabs.transform_values { wrap_and_normalize_properties _1 }

        wrapped_properties.each do |tab_name, properties|
          properties.each do |property|
            property_mapping[property.name] << tab_name
          end
        end

        super
      end

      # A sanity check if provided a new file
      wrapped_hook! def check_for_duplicates_across_tabs
        validations = property_mapping.map do |property_name, tab_names|
          if tab_names.one?
            Valid(property_name)
          else
            # :nocov:
            Invalid("#{property_name} in tabs: #{tab_names.to_sentence}")
            # :nocov:
          end
        end

        validated = List::Validated.coerce(validations).traverse.to_result

        yield validated

        super
      end

      wrapped_hook! def finalize
        @wrapped_tabs = wrapped_properties.map do |tab_name, properties|
          SolutionProperties::Admin::TabWrapper.new tab_name, properties
        end

        super
      end

      private

      # @param [<String>] list
      # @return [<SolutionProperties::Admin::PropertyWrapper>]
      def wrap_and_normalize_properties(list)
        list.flat_map { wrap_and_normalize_property _1 }.uniq
      end

      # @see SolutionProperties::Admin::PropertyWrapper
      # @return [<SolutionProperties::Admin::PropertyWrapper>]
      def wrap_and_normalize_property(name)
        property = SolutionProperty.lookup_coded_ext(name)

        SolutionProperties::Admin::PropertyWrapper.normalize(property)
      end
    end
  end
end
