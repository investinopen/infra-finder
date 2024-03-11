# frozen_string_literal: true

require_relative "boot"

module Support
  # A container for holding pre-initialization support services, generator helpers, etc.
  class System < Dry::System::Container
    use :zeitwerk
    use :bootsnap

    configure do |config|
      config.root = Pathname(__dir__)

      config.component_dirs.auto_register = true

      config.component_dirs.add "lib" do |dir|
        dir.auto_register = false

        dir.namespaces.add_root key: nil, const: "support"
      end

      config.component_dirs.add "operations" do |dir|
        dir.auto_register = true

        dir.namespaces.add_root key: nil, const: "support"
      end

      config.component_dirs.add "model_concerns" do |dir|
        dir.auto_register = false

        dir.namespaces.add_root key: nil, const: nil
      end

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym("API")
        inflections.acronym("HTML")
        inflections.acronym("URL")
      end
    end
  end

  Deps = Dry::AutoInject(System)
end

Support::System.start(:security)

Support::System.finalize!
