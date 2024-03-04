# frozen_string_literal: true

module TestingAPI
  # A container for holding test-related services and helpers.
  class TestContainer < Dry::System::Container
    use :zeitwerk
    use :bootsnap

    configure do |config|
      config.root = Pathname(__dir__)

      config.component_dirs.auto_register = true

      config.component_dirs.add "lib" do |dir|
        dir.auto_register = false

        dir.namespaces.add_root key: nil, const: "testing"
      end

      config.component_dirs.add "operations" do |dir|
        dir.auto_register = true

        dir.namespaces.add_root key: nil, const: "testing"
      end

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym("API")
      end
    end
  end

  Deps = Dry::AutoInject(TestContainer)
end
