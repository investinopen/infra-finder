# frozen_string_literal: true

module Solutions
  module Revisions
    class V2Data < Data
      filter_attributes! /\Aproperties\z/

      attribute :properties, Solutions::Revisions::V2PropertySet.to_type
    end
  end
end
