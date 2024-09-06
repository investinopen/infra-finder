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
        # :nocov:
        Solutions::Revisions::Data
        # :nocov:
      else
        # :nocov:
        raise "Unexpected revision version: #{v}"
        # :nocov:
      end
    end
  end
end
