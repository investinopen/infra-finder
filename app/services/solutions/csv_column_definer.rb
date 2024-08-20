# frozen_string_literal: true

module Solutions
  class CSVColumnDefiner < ::Admin::AbstractCSVColumnDefiner
    extend Dry::Core::Cache

    # @return [<String>]
    attr_reader :expected_properties

    # @return [<String>]
    attr_reader :exported_properties

    skip_public! :identifier

    skip_public! :governance_records_implementation, :governance_records

    skip_public! :current_affiliations, :founding_institutions, :recent_grants, :top_granting_institutions

    define_columns! def core_fields
      column! :identifier
      solution_column! :name
      solution_column! :provider_name
      solution_column! :founded_on
      solution_column! :country_code
      solution_column! :member_count

      solution_column! :contact
      solution_column! :first_name
      solution_column! :last_name
      solution_column! :email
      solution_column! :research_organization_registry_url
      solution_column! :website
      solution_column! :board_members_url
      solution_column! :membership_program_url
      solution_column! :logo
    end

    define_columns! def finances
      solution_column! :currency

      SolutionProperty.currency_values.each do |attr|
        solution_column!(attr)
      end

      solution_column! :financial_numbers_publishability
      solution_column! :financial_numbers_documented_url
      solution_column! :financial_date_range
      solution_column! :shareholders
    end

    define_columns! def blurbs
      SolutionProperty.blurb_values.each do |blurb|
        solution_column!(blurb)
      end
    end

    define_columns! def implementations
      Implementation.each do |impl|
        impl.each_property do |prop|
          solution_column! prop.name
        end
      end
    end

    define_columns! def store_model_lists
      SolutionProperty.store_model_lists.each do |list|
        solution_column!(list.name)
      end
    end

    define_columns! def controlled_vocabularies
      solution_column! :scoss

      SolutionProperty.in_use.with_model_vocab.order(code: :asc).each do |prop|
        solution_column! prop.name

        if prop.accepts_other?
          solution_column! prop.other_property.name
        end
      end
    end

    define_columns! def timestamps
      solution_column!(:created_at)
      solution_column!(:updated_at)
      solution_column!(:published_at)
      solution_column!(:publication)
    end

    define_columns! def structured
      return unless scope == :private

      Implementation.each do |impl|
        structured_column! impl
      end

      SolutionProperty.store_model_lists.each do |prop|
        structured_column! prop
      end
    end

    # @return [void]
    after_prepare def track_properties!
      @exported_properties = []
      @expected_properties = SolutionProperty.expected_to_handle_in_csv.pluck(:name)

      if scope == :private
        Implementation.each do |impl|
          expected_properties << impl.structured_header.to_s
        end

        SolutionProperty.store_model_lists.each do |prop|
          expected_properties << prop.structured_header.to_s
        end
      end
    end

    # @return [void]
    after_execute def check_properties!
      diff = expected_properties - exported_properties

      # :nocov:
      raise "Forgot to handle export for #{diff.inspect}" if diff.any?
      # :nocov:
    end

    private

    # @return [SolutionProperties::Accessors::AbstractAccessor]
    def accessor_for(name)
      fetch_or_store name do
        SolutionProperty.find(name.to_s).accessor
      end
    end

    def solution_column!(name, **options)
      accessor = accessor_for name

      track_property! accessor.property.name

      return unless accessor.property.export_for?(scope)

      column!(accessor.csv_header, **options) do |instance|
        accessor.output_csv!(instance)
      end
    end

    # @param [#structured_header, #structured_attr] structured
    # @return [void]
    def structured_column!(structured)
      track_property! structured.structured_header

      column! structured.structured_header do |instance|
        instance.__send__(structured.structured_attr)
      end
    end

    # @param [String] property_name
    # @return [void]
    def track_property!(property_name)
      exported_properties << property_name.to_s
    end
  end
end
