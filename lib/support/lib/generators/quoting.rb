# frozen_string_literal: true

module Support
  module Generators
    module Quoting
      module_function

      # @param [String] namespace
      # @return [void]
      def formatted_namespace_for(namespace, &)
        body = capture(&).strip_heredoc.strip

        parts = namespace.to_s.split("::").compact_blank

        if parts.empty?
          concat body

          return
        end

        opening = parts.each_with_index.map do |part, depth|
          "module #{part}".indent(depth * 2)
        end

        nested_body = body.indent(parts.length * 2)

        closing = parts.each_index.reverse_each.map do |depth|
          "end".indent(depth * 2)
        end

        output = [*opening, nested_body, *closing].join("\n")

        concat output
      end

      def quote_strong_params(input, indentation:)
        out = []

        out << ?[

        input.each do |param|
          case param
          in Symbol => key
            out << "#{quote_symbol(key).indent(2)},"
          in Hash => mapping
            out << ?{.indent(2)
            mapping.each do |key, value|
              out << "#{quote_symbolic_hash_key(key)}: #{quote_strong_params(value, indentation: 0)},".indent(4)
            end
            out << ?}.indent(2)
          end
        end

        out << ?]

        out.join("\n").indent(indentation).strip
      end

      # @param [#to_sym] key
      # @return [String]
      def quote_symbolic_hash_key(key) = quote_symbol(key).delete_prefix(?:)

      def quote_symbol(value) = value.to_sym.inspect
    end
  end
end
