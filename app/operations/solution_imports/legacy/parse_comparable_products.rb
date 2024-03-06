# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ParseComparableProducts
      include Dry::Monads[:result, :maybe, :do]

      ANCHOR_TAG = "<a"
      LIST_ITEM_TAG = "<li>"

      # @param [String, nil] input
      # @return [Dry::Monads::Success<Hash>]
      def call(input)
        return Success([]) if input.blank? || input.match?(/\Anone(?:.+currently)?\z/i)

        try_html(input).or do
          try_splitting(input).or do
            # :nocov:
            Success([{ name: input }])
            # :nocov:
          end
        end.to_result
      end

      private

      def try_html(input)
        return None() unless LIST_ITEM_TAG.in?(input) || input.starts_with?(ANCHOR_TAG)

        fragment = Nokogiri::HTML.fragment(input)

        if LIST_ITEM_TAG.in?(input)
          nodes = fragment.css("li").map do |li|
            name = li.children.select { _1.text? && _1.present? }.map(&:text).join(" ").squish

            name.gsub!(/\A\d+\)\s+/, "")

            # :nocov:
            return None() if name.blank?
            # :nocov:

            url = li.at_css("a[href]")&.attribute("href")&.text

            { name:, url:, }.compact_blank
          end

          return Maybe(nodes)
        elsif input.starts_with?(ANCHOR_TAG)
          nodes = fragment.css("a[href]").map do |a|
            name = a.text

            url = a.attribute("href").text

            { name:, url:, }.compact_blank
          end

          return Maybe(nodes)
        else
          # :nocov:
          return None()
          # :nocov:
        end
      end

      def try_splitting(input)
        nodes = input.split(/(?:\r?\n)+\s*/).compact_blank.map do |name|
          { name: name.strip, }
        end

        Maybe(nodes)
      end
    end
  end
end
