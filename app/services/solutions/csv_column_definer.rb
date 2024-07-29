# frozen_string_literal: true

module Solutions
  class CSVColumnDefiner < ::Admin::AbstractCSVColumnDefiner
    skip_public! :identifier, :provider_id, :contact_method

    skip_public! SolutionProperty.finance_values

    skip_public! :special_certifications_or_statuses

    skip_public! :governance_records_implementation, :governance_records

    skip_public! :current_affiliations, :founding_institutions, :recent_grants, :top_granting_institutions

    define_columns! def core_fields
      column! :identifier
      column! :name
      column!(:provider_id) do |solution|
        solution.provider_id
      end
      column!(:provider_name) do |solution|
        solution.provider_name
      end
      column! :founded_on
      column! :country_code
      column! :member_count

      column! :contact_method
      column! :contact
      column! :research_organization_registry_url
      column! :website
    end

    define_columns! def finances
      SolutionProperty.finance_values.each do |attr|
        column!(attr)
      end
    end

    define_columns! def blurbs
      SolutionProperty.blurb_values.each do |blurb|
        column!(blurb)
      end
    end

    define_columns! def implementations
      Implementation.each do |impl|
        column!(impl.enum)

        column!(impl.name) do |solution|
          solution.__send__(impl.name).to_csv
        end
      end
    end

    define_columns! def store_model_lists
      SolutionProperty.store_model_lists.each do |list|
        column!(list.name) do |solution|
          solution.__send__(list.attribute_name).as_json.compact_blank.to_json
        end
      end
    end

    define_columns! def single_options
      SolutionProperty.has_one_associations.each do |opt|
        column!(:"#{opt}_name") do |solution|
          solution.__send__(opt).try(:name)
        end
      end
    end

    define_columns! def multiple_options
      SolutionProperty.has_many_associations.each do |opt|
        single = opt.to_s.singularize.to_sym

        column!(:"#{single}_names") do |solution|
          solution.__send__(opt).pluck(:name).to_json
        end
      end
    end

    define_columns! def timestamps
      column!(:created_at)
      column!(:updated_at)
    end
  end
end
