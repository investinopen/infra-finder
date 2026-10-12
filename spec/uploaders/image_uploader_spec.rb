# frozen_string_literal: true

RSpec.describe ImageUploader do
  let_it_be(:solution) { FactoryBot.create :solution }

  context "with an SVG" do
    let(:svg) { Rails.root.join("spec", "data", "logo.svg").open("r") }

    before do
      solution.logo = svg
    end

    after do
      svg.close
    end

    it "is valid" do
      expect(solution.logo_attacher.errors).to be_blank
    end

    it "stores its dimensions" do
      expect(solution.logo.metadata).to include("width" => 400, "height" => 300)
    end

    it "creates PNG derivatives" do
      derivatives = solution.logo_attacher.create_derivatives

      aggregate_failures do
        expect(derivatives.keys).to match_array ImageUploader::SIZES.keys
        expect(derivatives[:thumb].mime_type).to eq "image/png"
        expect(derivatives[:thumb].metadata).to include("width" => 200, "height" => 150)
      end
    end
  end
end
