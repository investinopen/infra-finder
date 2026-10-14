# frozen_string_literal: true

RSpec.describe Types::BaseField do
  def complexity_of(query_string)
    query = GraphQL::Query.new(APISchema, query_string, context: { current_user: AnonymousUser.new })

    GraphQL::Analysis.analyze_query(query, [GraphQL::Analysis::QueryComplexity]).first
  end

  it "prices page-based connections by perPage" do
    expect(complexity_of("query { solutions(perPage: 10) { nodes { name drafts(perPage: 5) { nodes { name } } } } }")).to be < 200
  end

  it "prices them at the maximum page size without perPage" do
    expect(complexity_of("query { solutions { nodes { name drafts { nodes { name } } } } }")).to be > Support::GraphQLAPI::Constants::MAX_COMPLEXITY
  end
end
