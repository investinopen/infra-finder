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
