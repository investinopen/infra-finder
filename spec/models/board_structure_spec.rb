# frozen_string_literal: true

RSpec.describe BoardStructure, type: :model do
  it_behaves_like "a seeded option model"
  it_behaves_like "a solution option model"
end
