# frozen_string_literal: true

module Solutions
  module Revisions
    AnyData = StoreModel.one_of do |json|
      v = json.fetch("version") do
        json.fetch(:version, "unknown")
      end

      case v
      in /\Av2\z/
        Solutions::Revisions::V2Data
      in /\Aunknown\z/
        # simplecov:disable
        Solutions::Revisions::Data
        # simplecov:enable
      else
        # simplecov:disable
        raise "Unexpected revision version: #{v}"
        # simplecov:enable
      end
    end
  end
end
