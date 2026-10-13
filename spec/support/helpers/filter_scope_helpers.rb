# frozen_string_literal: true

require_relative "hash_setter"

module TestHelpers
  FilterHelpers = TestHelpers::HashSetter.new(:filter_args)
end

RSpec.shared_examples "filter scope default tests" do
  context "with the scope itself" do
    describe "the model relation" do
      subject { model_klass }

      before do
        # simplecov:disable
        skip "no required scopes" if described_class.required_scopes.empty?
        # simplecov:enable
      end

      described_class.required_scopes.each do |scope_name|
        it { is_expected.to respond_to(scope_name) }
      end
    end

    describe "the associated input object" do
      subject { described_class.input_object }

      it "exists" do
        is_expected.to be_a_kind_of(Class).and be < Types::FilterScopeInputObject
      end

      described_class.arguments.each do |key, dry_type|
        context "for the argument #{key}" do
          let(:typing) { dry_type.gql_typing }
          let(:input_key) { typing.input_key_for(key).to_s.camelize(:lower) }

          it do
            is_expected.to have_argument_named(input_key)
          end
        end
      end
    end
  end

  shared_examples_for "filters for a certifiable" do
    let_it_be(:claimed_record, refind: true) { FactoryBot.create(model_klass.default_factory).tap { _1.update_column(:claim_state, :claimed) } }
    let_it_be(:unclaimed_record, refind: true) { FactoryBot.create(model_klass.default_factory).tap { _1.update_column(:claim_state, :unclaimed) } }

    context "when filtering for claimed state" do
      let_filter_arg!(:claim_state_filter, key: :claim_state) { "claimed" }

      it "returns only claimed records" do
        expect_running.to include(claimed_record).and exclude(unclaimed_record)
      end
    end

    context "when filtering for unclaimed state" do
      let_filter_arg!(:claim_state_filter, key: :claim_state) { "unclaimed" }

      it "returns only unclaimed records" do
        expect_running.to include(unclaimed_record).and exclude(claimed_record)
      end
    end
  end

  shared_examples_for "filters for a name search" do
    let_it_be(:unique_name) { "Benedict Cumberbatch" }
    let_it_be(:similar_name) { "Benedict Arnold" }

    let_it_be(:record_with_unique_name, refind: true) { FactoryBot.create(model_klass.default_factory, name: unique_name) }
    let_it_be(:record_with_similar_name, refind: true) { FactoryBot.create(model_klass.default_factory, name: similar_name) }
    let_it_be(:record_with_non_matching_name, refind: true) { FactoryBot.create(model_klass.default_factory, name: "Some other name") }

    let(:needle) { unique_name }
    let(:strategy) { "fuzzy" }

    let_filter_arg!(:name_search_filter, key: :name_search) do
      Searching::Query.from(needle, strategy:)
    end

    context "when exact searching for a name" do
      let(:strategy) { "exact" }

      let(:needle) { unique_name }

      it "returns records matching the name exactly" do
        expect_running.to include(record_with_unique_name).and exclude(record_with_similar_name, record_with_non_matching_name)
      end
    end

    context "when fuzzy searching for a name" do
      let(:strategy) { "fuzzy" }

      it "returns records matching the name" do
        expect_running.to include(record_with_unique_name).and exclude(record_with_non_matching_name, record_with_similar_name)
      end

      context "when the needle is only a partial" do
        let(:needle) { "Cumber" }

        it "still finds the record" do
          expect_running.to include(record_with_unique_name)
        end
      end
    end

    context "when prefix searching for a name" do
      let(:needle) { "Benedict" }
      let(:strategy) { "prefix" }

      it "returns records matching the name's prefix" do
        expect_running.to include(record_with_unique_name, record_with_similar_name).and exclude(record_with_non_matching_name)
      end
    end
  end

  shared_examples_for "filters for a site resource" do
    context "when filtering by visibility" do
      let_it_be(:visible_record, refind: true) { FactoryBot.create(model_klass.default_factory) }
      let_it_be(:archived_record, refind: true) { FactoryBot.create(model_klass.default_factory, :archived) }

      context "when VISIBLE" do
        let_filter_arg!(:visibility_filter, key: :visibility) { "visible" }

        it "returns only visible records" do
          expect_running.to include(visible_record).and exclude(archived_record)
        end
      end

      context "when HIDDEN" do
        let_filter_arg!(:visibility_filter, key: :visibility) { "hidden" }

        it "returns only hidden records" do
          expect_running.to include(archived_record).and exclude(visible_record)
        end
      end

      context "when ARCHIVED_ONLY" do
        let_filter_arg!(:visibility_filter, key: :visibility) { "archived_only" }

        it "returns only archived records" do
          expect_running.to include(archived_record).and exclude(visible_record)
        end
      end

      context "when ALL" do
        let_filter_arg!(:visibility_filter, key: :visibility) { "all" }

        it "returns all records regardless of visibility" do
          expect_running.to include(visible_record, archived_record)
        end
      end
    end
  end

  shared_examples_for "filters for a taggable record" do
    let_it_be(:internal_tags) { %w[internal-tag-1] }
    let_it_be(:external_tags) { %w[external-tag-1] }
    let_it_be(:internally_tagged_record, refind: true) { FactoryBot.create(model_klass.default_factory, internal_tags:) }
    let_it_be(:externally_tagged_record, refind: true) { FactoryBot.create(model_klass.default_factory, external_tags:) }
    let_it_be(:untagged_record, refind: true) { FactoryBot.create(model_klass.default_factory) }

    let_it_be(:admin_user, refind: true) { FactoryBot.create(:user, :admin) }

    def tag_search_for(*tags, any: false)
      tags.flatten!

      ::Taggings::TagSearch.new(tags:, any:)
    end

    context "when filtering for external tags" do
      let_filter_arg!(:external_tags_filter, key: :external_tags) { tag_search_for(external_tags) }

      it "returns records matching the external tags" do
        expect_running.to include(externally_tagged_record).and exclude(internally_tagged_record, untagged_record)
      end
    end

    context "when filtering for internal tags" do
      let_filter_arg!(:internal_tags_filter, key: :internal_tags) { tag_search_for(internal_tags) }

      context "when the user has no permissions" do
        let(:current_user) { anonymous_user }

        it "nullifies the scope and returns nothing" do
          expect_running.to exclude(internally_tagged_record, externally_tagged_record, untagged_record)
        end
      end

      context "when the user has admin permissions" do
        let(:current_user) { admin_user }

        it "returns records matching the internal tags" do
          expect_running.to include(internally_tagged_record).and exclude(externally_tagged_record, untagged_record)
        end
      end
    end
  end
end

RSpec.shared_context "filter scope tests" do
  let_it_be(:anonymous_user) { AnonymousUser.new }

  let_it_be(:model_klass) { described_class.model_klass }

  let(:options) { filter_args }

  let_it_be(:filter_klass) { described_class }

  let(:base_scope) { model_klass.all }

  let(:current_user) { anonymous_user }

  let(:runner_options) do
    {
      base_scope:,
      current_user:,
      filter_klass:,
      options:,
    }
  end

  def run_filters
    Common::Container["filtering.run"].(model_klass, **runner_options).value!
  end

  def expect_running
    expect(run_filters)
  end

  include_examples "filter scope default tests"
end

RSpec.configure do |config|
  config.include TestHelpers::FilterHelpers, type: :filter_scope
  config.include_context "filter scope tests", type: :filter_scope
end
