# frozen_string_literal: true

module PageMeta
  class Properties < Support::WritableStruct
    attribute :site_title, Types::SiteTitle
    attribute :no_index, Types::Bool.default(false)
    attribute? :canonical_url, Types::URL.optional

    def no_index!
      self.no_index = true
    end
  end
end
