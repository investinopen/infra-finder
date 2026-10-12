# frozen_string_literal: true

RSpec.describe Admin::ActionPolicyAdapter, default_auth: true do
  let_it_be(:other_provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:other_solution, refind: true) { FactoryBot.create :solution, provider: other_provider }

  let(:namespace) { ActiveAdmin.application.tap(&:load!).namespaces[:admin] }

  let(:resource) { namespace.resources[Solution] }

  def adapter_for(user, resource: self.resource)
    described_class.new(resource, user)
  end

  describe "#authorized?" do
    it "maps reading a class to index?" do
      aggregate_failures do
        expect(adapter_for(editor).authorized?(:read, Solution)).to be true
        expect(adapter_for(regular_user).authorized?(:read, Solution)).to be false
      end
    end

    it "maps reading a record to show?" do
      aggregate_failures do
        expect(adapter_for(editor).authorized?(:read, solution)).to be true
        expect(adapter_for(editor).authorized?(:read, other_solution)).to be false
      end
    end

    it "maps destroying a class to destroy_all? and a record to destroy?" do
      aggregate_failures do
        expect(adapter_for(super_admin).authorized?(:destroy, Solution)).to be true
        expect(adapter_for(admin).authorized?(:destroy, Solution)).to be false
        expect(adapter_for(super_admin).authorized?(:destroy, solution)).to be true
        expect(adapter_for(admin).authorized?(:destroy, solution)).to be false
      end
    end

    it "maps other actions to their predicate rule" do
      aggregate_failures do
        expect(adapter_for(admin).authorized?(:publish_all, Solution)).to be true
        expect(adapter_for(editor).authorized?(:publish_all, Solution)).to be false
      end
    end

    it "uses a model's policy_class" do
      aggregate_failures do
        expect(adapter_for(admin).authorized?(:replace, License)).to be true
        expect(adapter_for(editor).authorized?(:replace, License)).to be false
      end
    end

    it "falls back to ApplicationPolicy for subjects without a policy" do
      aggregate_failures do
        expect(adapter_for(super_admin).authorized?(:batch_action, :publish_all)).to be true
        expect(adapter_for(admin).authorized?(:batch_action, :publish_all)).to be false
      end
    end

    it "authorizes the resource when no subject is given" do
      dashboard = namespace.resources.detect { _1.is_a?(ActiveAdmin::Page) && _1.name == "Dashboard" } or raise "no dashboard page"

      aggregate_failures do
        expect(adapter_for(editor, resource: dashboard).authorized?(:read)).to be true
        expect(adapter_for(regular_user, resource: dashboard).authorized?(:read)).to be false
      end
    end

    it "denies rules the policy does not define" do
      expect(adapter_for(super_admin).authorized?(:nonexistent, solution)).to be false
    end
  end

  describe "#scope_collection" do
    it "applies the policy's relation scope" do
      aggregate_failures do
        expect(adapter_for(admin).scope_collection(Solution.all)).to contain_exactly(solution, other_solution)
        expect(adapter_for(editor).scope_collection(Solution.all)).to contain_exactly(solution)
        expect(adapter_for(regular_user).scope_collection(Solution.all)).to be_empty
      end
    end
  end

  describe "as a ransack auth object" do
    it "exposes the same attributes as its user" do
      aggregate_failures do
        [admin, regular_user].each do |user|
          expect(User.ransackable_attributes(adapter_for(user))).to eq User.ransackable_attributes(user)
        end

        expect(User.ransackable_attributes(adapter_for(regular_user))).not_to eq User.ransackable_attributes(adapter_for(admin))
      end
    end
  end
end
