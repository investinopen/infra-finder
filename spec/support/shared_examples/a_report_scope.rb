# frozen_string_literal: true

RSpec.shared_examples_for "a report scope" do
  include_context "report scoping"

  let(:scope_filters) do
    nil
  end

  let(:scope_args) do
    {}
  end

  let(:scope_options) do
    { **scope_args }.tap do |h|
      if described_class.filters_klass && scope_filters.present?
        h[:filters] = described_class.filters_klass.new(**scope_filters)
      end
    end
  end

  let(:category_instance) do
    global_scope.public_send described_class.category.field_name
  end

  def call_the_scope
    category_instance.public_send described_class.field_name, **scope_options
  end

  it "produces a report token that enumerates without issue" do
    expect do
      @token = call_the_scope
    end.to change(ReportToken, :count).by(1)

    expect do
      expect(@token.enumerate).to succeed
    end.to execute_safely
  end
end
