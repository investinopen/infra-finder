# frozen_string_literal: true

module Solutions
  # @see Solutions::CalculateFlags
  # @see Solutions::FlagsCalculator
  class Flags
    include Support::EnhancedStoreModel

    # 1) is OSS
    attribute :oss, :boolean, default: false
    # 2) distributes open access content
    attribute :open_access_content, :boolean, default: false
    # 3) is free to use by anyone
    attribute :free_to_use, :boolean, default: false
    # 4) is community-governed and transparent
    attribute :transparent_governance, :boolean, default: false
    # 5) is operated by a non-profit
    attribute :nonprofit_operated, :boolean, default: false

    class << self
      # @return [{ Symbol => Symbol }]
      def scopes
        @scopes ||= attribute_names.without("transparent_governance", "nonprofit_operated").to_h { [_1.to_sym, :"flagged_#{_1}"] }
      end
    end
  end
end
