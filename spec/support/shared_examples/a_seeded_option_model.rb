# frozen_string_literal: true

RSpec.shared_examples_for "a seeded option model" do
  let_it_be(:factory_kind) { described_class.factory_bot_name }

  describe ".seed_for!" do
    let(:seed_identifier) { 1 }

    let(:name) { "Some Record" }

    let(:base_row) { { name:, } }

    it "can seed a record by its identifier idempotently" do
      row = base_row.to_h.symbolize_keys.merge(seed_identifier:)

      expect do
        described_class.seed_for!(seed_identifier, row)
      end.to change(described_class, :count).by(1)

      record = described_class.find_by!(seed_identifier:)

      temp_name = "some temp name"

      record.assign_attributes(name: temp_name)

      record.save!(validate: false)

      expect do
        described_class.seed_for!(seed_identifier, row)
      end.to keep_the_same(described_class, :count)
        .and change { record.reload.name }.from(temp_name).to(name)
    end
  end
end
