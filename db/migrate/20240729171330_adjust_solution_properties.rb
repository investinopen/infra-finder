# frozen_string_literal: true

class AdjustSolutionProperties < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  DEPRECATED_FIELDS = %i[
    comparable_products
    financial_numbers_applicability
    registered_service_provider_description
    special_certifications_or_statuses
    standards_employed
  ].freeze

  MONEY_FIELDS = %i[
    annual_expenses
    annual_revenue
    investment_income
    other_revenue
    program_revenue
    total_assets
    total_contributions
    total_liabilities
  ].freeze

  COUNTRY_MAPPING = {
    # eclipse-pass offices in ottawa
    "Belgium, Canada, United States" => "CA",
    "Brazil" => "BR",
    "Canada" => "CA",
    "France" => "FR",
    "Germany" => "DE",
    "Italy" => "IT",
    "Malawi" => "MW",
    "Netherlands" => "NL",
    "New York, New York, United States of America" => "US",
    "Switzerland" => "CH",
    "United Kingdom" => "GB",
    "United States" => "US",
    "United States of America" => "US",
    "Uruguay" => "UY",
  }.freeze

  def change
    TABLES.each do |table|
      deprecate_fields! table

      migrate_location! table

      migrate_money_for! table
    end
  end

  private

  def deprecate_fields!(table)
    change_table table do |t|
      DEPRECATED_FIELDS.each do |field|
        t.rename field, :"phase_1_#{field}"
      end
    end
  end

  def migrate_location!(table)
    change_table table do |t|
      t.rename :location_of_incorporation, :phase_1_location_of_incorporation

      t.citext :country_code
    end

    reversible do |dir|
      dir.up do
        COUNTRY_MAPPING.each do |(legacy, country_code)|
          quoted_legacy = connection.quote legacy
          quoted_country_code = connection.quote country_code

          say_with_time "Migrating #{table} phase 1 locations: #{legacy.inspect} => #{country_code.inspect}" do
            exec_update <<~SQL
            UPDATE #{table} SET country_code = #{quoted_country_code} WHERE phase_1_location_of_incorporation = #{quoted_legacy};
            SQL
          end
        end
      end
    end
  end

  def migrate_money_for!(table)
    change_table table do |t|
      t.citext :currency, null: false, default: "USD"

      MONEY_FIELDS.each do |field|
        t.rename field, :"phase_1_#{field}"

        t.monetize field, currency: { present: false }
      end
    end

    reversible do |dir|
      dir.up do
        say_with_time "Migrating #{table} original phase 1 currency values" do
          statements = MONEY_FIELDS.map { "#{_1}_cents = COALESCE(phase_1_#{_1}, 0) * 100" }.join(", ")
          exec_update <<~SQL
          UPDATE #{table} SET #{statements}
          SQL
        end
      end
    end
  end
end
