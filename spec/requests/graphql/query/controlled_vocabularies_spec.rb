# frozen_string_literal: true

RSpec.describe "Query.controlledVocabularies", type: :request, graphql: true do
  let(:query) do
    <<~GRAPHQL
    query getControlledVocabularies($order: ControlledVocabularyOrder) {
      controlledVocabularies(order: $order) {
        kind
        label
        recordsCount
        extraFields {
          name
          type
          required
        }
      }
    }
    GRAPHQL
  end

  let(:graphql_variables) { { order: }.compact }

  let(:sorted_entries) { ControlledVocabularyEntry.as_model.lazily_order(column, direction).to_a }

  let(:expected_shape) do
    gql.query do |q|
      q.array :controlled_vocabularies do |cvs|
        sorted_entries.each do |entry|
          cvs.item do |cv|
            cv[:records_count] = entry.records_count

            cv[:kind] = Types::ControlledVocabularyKindType.name_for_value(entry.kind)
            cv[:label] = entry.label

            case entry.kind
            in "License"
              cv.array :extra_fields do |efs|
                efs.item do |ef|
                  ef[:name] = "url"
                  ef[:type] = "STRING"
                  ef[:required] = false
                end
              end
            in "Staffing"
              cv.array :extra_fields do |efs|
                efs.item do |ef|
                  ef[:name] = "minValue"
                  ef[:type] = "INTEGER"
                  ef[:required] = false
                end

                efs.item do |ef|
                  ef[:name] = "maxValue"
                  ef[:type] = "INTEGER"
                  ef[:required] = false
                end
              end
            else
              cv[:extra_fields] = []
            end
          end
        end
      end
    end
  end

  before_all do
    ControlledVocabularies::SyncEntriesJob.perform_now
  end

  as_an_anonymous_user do
    # Records count orders can tie, so only the counts themselves are stable.
    where(:case_name, :order, :column, :direction) do
      [
        ["the default order", nil, :name, :asc],
        ["NAME_ASCENDING", "NAME_ASCENDING", :name, :asc],
        ["NAME_DESCENDING", "NAME_DESCENDING", :name, :desc],
        ["RECORDS_COUNT_ASCENDING", "RECORDS_COUNT_ASCENDING", :records_count, :asc],
        ["RECORDS_COUNT_DESCENDING", "RECORDS_COUNT_DESCENDING", :records_count, :desc],
      ]
    end

    with_them do
      it "lists every model-backed vocabulary in the right order" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end
end
