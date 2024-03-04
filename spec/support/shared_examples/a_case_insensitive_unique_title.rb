# frozen_string_literal: true

RSpec.shared_examples_for "a model with a case-insensitive, unique title" do
  let(:factory) { described_class.model_name.i18n_key }

  let!(:existing) { FactoryBot.create factory, title: "Some Title" }
  let(:attempted) { FactoryBot.build factory, title: "some title" }

  context "when validating the uniqueness of a title" do
    it "is case insensitive" do
      expect(attempted).to be_invalid
    end
  end
end
