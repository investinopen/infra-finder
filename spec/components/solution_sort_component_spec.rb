# frozen_string_literal: true

RSpec.describe SolutionSortComponent, type: :component do
  it "supports last_updated" do
    expect(render_preview(:last_updated).css("option[selected]").inner_text).to eq described_class.t(".sorts.updated_at.desc")
  end

  it "supports name asc" do
    expect(render_preview(:name_asc).css("option[selected]").inner_text).to eq described_class.t(".sorts.name.asc")
  end

  it "supports name desc" do
    expect(render_preview(:name_desc).css("option[selected]").inner_text).to eq described_class.t(".sorts.name.desc")
  end
end
