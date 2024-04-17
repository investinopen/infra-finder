# frozen_string_literal: true

class AddMissingBlurb < ActiveRecord::Migration[7.1]
  LEGACY_SOLUTIONS = Rails.root.join("vendor", "legacy-solutions.csv")

  def change
    return unless LEGACY_SOLUTIONS.exist?

    reversible do |dir|
      dir.up do
        tbl = CSV.table(LEGACY_SOLUTIONS)

        pairings = tbl.pluck(:id, :engagement_with_values_frameworks).each_with_object([]) do |(id, value), pairs|
          next if value.blank? || /\ANULL\z/i.match?(value)

          pairs << [id.to_s, value]
        end

        say_with_time "backfilling Solution.engagement_with_values_frameworks" do
          pairings.sum do |(identifier, engagement_with_values_frameworks)|
            Solution.where(identifier:, engagement_with_values_frameworks: [nil, ""]).update_all(engagement_with_values_frameworks:)
          end
        end
      end
    end
  end
end
