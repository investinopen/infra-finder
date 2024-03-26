# frozen_string_literal: true

RSpec.describe TagListComponent, type: :component do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution, :with_key_technologies }

  context "when name: :key_technologies" do
    let(:name) { :key_technologies }

    it "renders a list of tags" do
      expect(render_inline(described_class.new(solution:, name:)).to_html).to include "ruby"
    end
  end
end
