# frozen_string_literal: true

module SolutionImports
  module Legacy
    # @api private
    # @see License
    # @see SolutionCategory
    # @see SolutionOption::Multiple
    # @see UserContribution
    class LookupMultipleOptions
      include Dry::Core::Memoizable
      include Dry::Monads[:result, :do]

      MAPPING = {
        license: {
          "AGPL" => 8,
          "Apache License, Version 2.0" => 1,
          "BSD Licenses" => 2,
          "CC-BY-SA" => 9,
          "CC0" => 7,
          "GNU General Public License (GPL)" => 3,
          "ISC License" => 10,
          "MIT License" => 4,
        },
        solution_category: {
          "Annotations system" => 1,
          "Archive information management system" => 2,
          "Authoring" => 23,
          "Authoring tool" => 3,
          "Authority management system" => 24,
          "Book publishing software" => 25,
          "Data repository software" => 26,
          "Digital asset management system" => 4,
          "Digital library, collection or exhibit platform" => 5,
          "Disciplinary repository software" => 27,
          "Discovery system" => 6,
          "Federated identity or authentication management" => 7,
          "Index or directory" => 8,
          "Informal scholarly communications" => 9,
          "Institutional repository software" => 28,
          "Journal software system" => 29,
          "Media viewer/player" => 10,
          "Open access or subscription management tool" => 11,
          "Open access policy information compilation" => 12,
          "Open scholarly dataset" => 13,
          "Peer review system" => 14,
          "Peer review systems" => 30,
          "Persistent identifier service" => 15,
          "Personal information management system" => 31,
          "Preservation system" => 16,
          "Publishing system" => 17,
          "Repository service" => 18,
          "Repository software" => 19,
          "Research profiling system" => 20,
          "Standard, specification, or protocol" => 21,
          "Submission system" => 22,
        },
        user_contribution: {
          "Automated link checking" => 21,
          "Code" => 1,
          "Community Tools" => 6,
          "Contribute reviews" => 12,
          "Contribute to governance" => 23,
          "Contribute to shaping tools and resources" => 9,
          "Contribute to user research design sprints" => 11,
          "Development Roadmap" => 18,
          "Documentation" => 2,
          "Education / Training" => 4,
          "Funds" => 5,
          "Improvement of metadata quality" => 20,
          "Lead and participate in collaborative peer review clubs" => 13,
          "Metadata and Registration Templates" => 7,
          "Participate in PREreview-facilitated live review sessions" => 16,
          "Participate in user research design sprints" => 15,
          "Participate in user research interviews" => 14,
          "Provide comments for consideration as enhancements or extensions" => 8,
          "Request and participate in special interest Slack channels" => 17,
          "Usability Testing" => 24,
          "User Research" => 10,
          "User Research Design Sprints" => 22,
          "Working / Interest Groups" => 3,
        }
      }.with_indifferent_access.freeze

      OptionKlass = Types::Class.constrained(inherits: SolutionOption::Multiple)

      # @param [Class<SolutionOption::Multiple>] klass
      # @param [String, nil] raw_value
      # @return [Dry::Monads::Success<SolutionOption::Multiple>]
      def call(klass, raw_value)
        yield OptionKlass.try(klass).to_monad

        input = normalize(raw_value)

        matcher = matcher_for(klass.legacy_import_lookup_key)

        seed_identifier = matcher.(input)

        records = klass.seeded.where(seed_identifier:).to_a

        Success records
      end

      private

      # @param [Symbol] lookup_key
      # @return [Matcher]
      memoize def matcher_for(lookup_key)
        lookups = MAPPING.fetch(lookup_key)

        Matcher.new(lookups)
      end

      # Some exports from the database have an errant `\b` character in them.
      #
      # We'll remove that and enforce a string.
      #
      # @param [#to_s] raw_value
      # @return [String]
      def normalize(raw_value)
        raw_value.to_s.gsub("\b", "")
      end

      # @api private
      class Matcher
        include Dry::Initializer[undefined: false].define -> do
          param :lookups, Types::Hash.map(Types::String, Types::Integer)
        end

        # @param [String] input
        # @return [<Integer>] an array of seed identifiers
        def call(input)
          found = input.scan(pattern).to_a.uniq

          lookups.values_at(*found)
        end

        private

        # @!attribute [r] pattern
        # @return [Regexp]
        def pattern
          @pattern ||= Regexp.union(lookups.keys.sort.reverse)
        end
      end
    end
  end
end
