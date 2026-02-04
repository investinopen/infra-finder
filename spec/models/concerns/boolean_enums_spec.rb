# frozen_string_literal: true

RSpec.describe BooleanEnums do
  include described_class

  describe ".accept_boolean_value_for" do
    let(:truthy) { "truthy value" }
    let(:falsey) { "falsey value" }
    let(:null) { "nullish value" }

    def calling_with(value)
      accept_boolean_value_for(value, truthy:, falsey:, null:)
    end

    it "returns the right value for truthy values", :aggregate_failures do
      expect(calling_with(true)).to eq(truthy)
      expect(calling_with("true")).to eq(truthy)
      expect(calling_with("1")).to eq(truthy)
      expect(calling_with(1)).to eq(truthy)
      expect(calling_with("y")).to eq(truthy)
    end

    it "returns the right value for falsey values", :aggregate_failures do
      expect(calling_with(false)).to eq(falsey)
      expect(calling_with("false")).to eq(falsey)
      expect(calling_with("0")).to eq(falsey)
      expect(calling_with(0)).to eq(falsey)
      expect(calling_with("n")).to eq(falsey)
      expect(calling_with("no")).to eq(falsey)
    end

    it "returns the right value for null values", :aggregate_failures do
      expect(calling_with(nil)).to eq(null)
      expect(calling_with("null")).to eq(null)
      expect(calling_with("nil")).to eq(null)
      expect(calling_with("")).to eq(null)
    end

    it "acts as a pass-through for non-matchable values" do
      expect(calling_with("unexpected")).to eq("unexpected")
      expect(calling_with(42)).to eq(42)
    end
  end
end
