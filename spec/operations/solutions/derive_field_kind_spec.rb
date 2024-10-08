# frozen_string_literal: true

RSpec.describe Solutions::DeriveFieldKind, type: :operation do
  it "fails with an unknown field" do
    expect_calling_with(:some_unknown_field).to monad_fail.with_key(:unknown_field)
  end

  it "meets some minimum expectations", :aggregate_failures do
    expect_calling_with(:logo).to succeed.with(:attachment)
    expect_calling_with(:service_summary).to succeed.with(:blurb)
    expect_calling_with(:bylaws).to succeed.with(:implementation)
    expect_calling_with(:licenses).to succeed.with(:multi_option)
    expect_calling_with(:hosting_strategy).to succeed.with(:single_option)
    expect_calling_with(:comparable_products).to succeed.with(:store_model_list)
    # expect_calling_with(:financial_numbers_applicability).to succeed.with(:enum)
    expect_calling_with(:founded_on).to succeed.with(:date)
  end

  specify "kitchen-sink test", :aggregate_failures do
    SolutionProperty.to_clone.each do |attr|
      expect_calling_with(attr).to succeed
    end
  end
end
