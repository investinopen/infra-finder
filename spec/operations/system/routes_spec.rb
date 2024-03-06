# frozen_string_literal: true

RSpec.describe System::Routes, type: :operation do
  it "can generate full urls" do
    expect(operation.root_url).to start_with LocationsConfig.root
  end
end
