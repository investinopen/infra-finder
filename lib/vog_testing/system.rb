# frozen_string_literal: true

require_relative "boot"

module VOGTesting
  # A container for holding development & testing-only support services, generator helpers, etc.
  class System < Dry::System::Container
    use :zeitwerk

    configure do |config|
      config.root = Pathname(__dir__)

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym("API")
        inflections.acronym("GQL")
        inflections.acronym("GraphQL")
        inflections.acronym("HTTP")
        inflections.acronym("JSON")
        inflections.acronym("SSL")
        inflections.acronym("TLS")
        inflections.acronym("URL")
        inflections.acronym("VOG")
      end

      config.component_dirs.auto_register = true

      config.component_dirs.add "operations" do |dir|
        dir.auto_register = true

        dir.namespaces.add_root key: nil, const: nil
        dir.namespaces.add "vog_testing", key: nil, const: "VOGTesting"
      end

      config.component_dirs.add "services" do |dir|
        dir.auto_register = false

        dir.namespaces.add_root key: nil, const: nil
      end

      register :gql, memoize: true do
        VOGTesting::GQLShaper.new
      end

      register "tokens.helper", memoize: true do
        VOGTesting::Tokens::Helper.new
      end
    end
  end

  Deps = Dry::AutoInject(VOGTesting)

  class << self
    delegate :[], to: System

    # @return [Pathname]
    def root
      System.root
    end
  end
end

VOGTesting::System.finalize!
