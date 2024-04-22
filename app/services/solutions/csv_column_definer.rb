# frozen_string_literal: true

module Solutions
  class CSVColumnDefiner < ::Admin::AbstractCSVColumnDefiner
    skip_public! :identifier, :provider_id, :contact_method

    skip_public! SolutionInterface::FINANCES

    skip_public! :special_certifications_or_statuses

    skip_public! :governance_activities_implementation, :governance_activities

    skip_public! :comparable_products, :current_affiliations, :founding_institutions, :recent_grants, :top_granting_institutions

    skip_public!(*SolutionInterface::SINGLE_OPTIONS.map { :"#{_1}_id" })

    skip_public!(*SolutionInterface::MULTIPLE_OPTIONS.map { :"#{_1.to_s.singularize}_ids" })

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
      column! :location_of_incorporation
      column! :current_staffing
      column! :member_count
      column! :maintenance_status

      column! :contact_method
      column! :contact
      column! :research_organization_registry_url
      column! :website
    end

    define_columns! def finances
      SolutionInterface::FINANCES.each do |attr|
        column!(attr)
      end
    end

    define_columns! def blurbs
      SolutionInterface::BLURBS.each do |blurb|
        column!(blurb)
      end
    end

    define_columns! def implementations
      SolutionInterface::IMPLEMENTATIONS_WITH_ENUMS.in_groups_of(2).each do |(impl, enum)|
        column!(enum)

        column!(impl) do |solution|
          solution.__send__(impl).to_csv
        end
      end
    end

    define_columns! def store_model_lists
      SolutionInterface::STORE_MODEL_LISTS.each do |list|
        column!(list) do |solution|
          solution.__send__(list).as_json.compact_blank.to_json
        end
      end
    end

    define_columns! def tag_lists
      SolutionInterface::TAG_LISTS.each do |tags|
        column!(tags) do |solution|
          solution.__send__(tags).join(?,)
        end
      end
    end

    define_columns! def single_options
      SolutionInterface::SINGLE_OPTIONS.each do |opt|
        column!(:"#{opt}_id")

        column!(:"#{opt}_name") do |solution|
          solution.__send__(opt).try(:name)
        end
      end
    end

    define_columns! def multiple_options
      SolutionInterface::MULTIPLE_OPTIONS.each do |opt|
        single = opt.to_s.singularize.to_sym

        column!(:"#{single}_ids")

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
