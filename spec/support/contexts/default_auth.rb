# frozen_string_literal: true

RSpec.shared_context "default auth" do
  let_it_be(:super_admin, refind: true) { FactoryBot.create :user, :with_super_admin }

  let_it_be(:admin, refind: true) { FactoryBot.create :user, :with_admin }

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:solution, refind: true) { FactoryBot.create(:solution, provider:) }

  let_it_be(:editor, refind: true) do
    FactoryBot.create(:user, :accepted_terms) do |u|
      solution.assign_editor!(u)
    end
  end

  let_it_be(:regular_user, refind: true) do
    FactoryBot.create :user, :accepted_terms
  end

  # @see ApplicationController#access_denied
  let_it_be(:unauthorized_path) { ?/ }
end

RSpec.configure do |config|
  config.include_context "default auth", default_auth: true
  config.include_context "default auth", type: :policy
end
