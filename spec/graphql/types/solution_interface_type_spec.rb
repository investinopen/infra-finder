# frozen_string_literal: true

RSpec.describe Types::SolutionInterfaceType do
  let(:schema) do
    object_type = Class.new(Types::BaseObject) do
      graphql_name "TestSolution"

      implements Types::SolutionInterfaceType
    end

    query_type = Class.new(Types::BaseObject) do
      graphql_name "TestQuery"

      field :solution, object_type, null: false do
        argument :id, GraphQL::Types::ID, required: true
      end

      def solution(id:) = Solution.find(id)
    end

    Class.new(GraphQL::Schema) do
      query query_type

      use GraphQL::Dataloader
    end
  end

  let_it_be(:license, refind: true) { FactoryBot.create :license, name: "MIT" }

  let_it_be(:admin, refind: true) { FactoryBot.create :user, :with_admin }

  let_it_be(:solution, refind: true) do
    FactoryBot.create(:solution).tap do |solution|
      solution.update!(
        licenses: [license],
        annual_revenue_cents: 123_456,
        currency: "EUR",
        code_repository_implementation: "available",
        code_repository: { links: [{ url: "https://example.org/repo" }], statement: "Public" },
        recent_grants: [{ name: "Big Grant", funder: "Foundation" }]
      )
    end
  end

  let(:query) do
    <<~GRAPHQL
    query($id: ID!) {
      solution(id: $id) {
        name
        licenses { name }
        annualRevenue { amount currency cents }
        codeRepositoryImplementation
        codeRepository { links { url } statement }
        codeLicense { link { url } }
        recentGrants { name funder }
      }
    }
    GRAPHQL
  end

  describe "money" do
    let(:query) { "query($id: ID!) { solution(id: $id) { annualRevenue { amount } } }" }

    it "uses the currency's decimal places" do
      solution.update!(annual_revenue_cents: 100_000, currency: "USD")

      result = schema.execute(query, variables: { id: solution.id }, context: { current_user: admin }).to_h

      expect(result.dig("data", "solution", "annualRevenue", "amount")).to eq "1000.00"
    end
  end

  it "resolves every kind of generated field from a solution" do
    result = schema.execute(query, variables: { id: solution.id }, context: { current_user: admin }).to_h

    expect(result["errors"]).to be_blank

    expect(result.dig("data", "solution")).to include(
      "name" => solution.name,
      "licenses" => [{ "name" => "MIT" }],
      "annualRevenue" => { "amount" => "1234.56", "currency" => "EUR", "cents" => "123456" },
      "codeRepositoryImplementation" => "AVAILABLE",
      "codeRepository" => { "links" => [{ "url" => "https://example.org/repo" }], "statement" => "Public" },
      "codeLicense" => { "link" => nil },
      "recentGrants" => [{ "name" => "Big Grant", "funder" => "Foundation" }]
    )
  end

  describe "hidden values" do
    let(:query) { "query($id: ID!) { solution(id: $id) { name annualRevenue { amount } recentGrants { name } } }" }

    before { solution.published! }

    def execute_as(user)
      schema.execute(query, variables: { id: solution.id }, context: { current_user: user }).to_h.dig("data", "solution")
    end

    it "shows them to admins" do
      expect(execute_as(admin)).to include("annualRevenue" => be_present, "recentGrants" => be_present)
    end

    it "hides them from the public" do
      expect(execute_as(AnonymousUser.new)).to include("name" => solution.name, "annualRevenue" => nil, "recentGrants" => nil)
    end

    it "shows financial numbers to the public once they are approved for publishing" do
      solution.financial_numbers_approved_to_publish!

      expect(execute_as(AnonymousUser.new)).to include("annualRevenue" => be_present, "recentGrants" => nil)
    end
  end
end
