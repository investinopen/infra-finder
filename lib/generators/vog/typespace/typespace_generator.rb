# frozen_string_literal: true

module VOG
  class TypespaceGenerator < Rails::Generators::NamedBase
    namespace "vog:typespace"

    source_root File.expand_path("templates", __dir__)

    def create_types!
      destination = Rails.root.join("app/services/#{service_namespace.underscore}/types.rb")

      if destination.exist?
        say_status :skip, "#{destination} already exists", :yellow
        return
      end

      template "types.rb", destination
    end

    private

    def service_namespace = class_name.pluralize
  end
end
