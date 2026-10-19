# frozen_string_literal: true

RSpec.describe Processing::RegenerateDerivativesJob, type: :job do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  before do
    solution.logo_attacher.attach Rails.root.join("spec", "data", "logo.svg").open("r")
    solution.logo_attacher.add_derivatives({ thumb: Rails.root.join("spec", "data", "lorempixel.jpg").open("r") }, delete: false)
    solution.save!
  end

  it "replaces flat derivatives with a WebP and PNG for each size" do
    old_thumb = solution.logo_derivatives[:thumb]

    expect do
      described_class.perform_now(solution, "logo")
    end.to change { solution.reload.logo_derivatives.keys }.from([:thumb]).to(match_array(ImageAttachments::Constants::IMAGE_SIZES.keys))

    expect(solution.logo(:thumb, :webp)).to be_present
    expect(old_thumb).not_to exist
  end
end
