# frozen_string_literal: true

module VOG
  class FilteringScopeGenerator < Rails::Generators::NamedBase
    namespace "vog:filtering_scope"

    source_root File.expand_path("templates", __dir__)

    FILTERING_INPUTS = Rails.root.join("app", "graphql", "types", "filtering")

    FILTER_SCOPE_SPECS = Rails.root.join("spec", "services", "filtering", "scopes")

    def build_filter_input_type
      # Necessary to ensure that all types are properly loaded
      # before we attempt to reference them. Cyclical dependencies
      # can arise otherwise.
      # Rails.application.eager_load!

      template "filter_input.rb.tt", FILTERING_INPUTS.join(
        "#{collapsed_file_name}_filter_input_type.rb"
      )
    end

    def build_filter_scope_spec
      destination = FILTER_SCOPE_SPECS.join("#{file_path.pluralize}_spec.rb")

      if destination.exist?
        say_status :skip, "#{destination} already exists", :yellow
        return
      end

      template "filter_scope_spec.rb.tt", destination
    end

    private

    # The class name with any namespacing collapsed, e.g. `Snapshots::User` => `SnapshotsUser`.
    #
    # GraphQL types are flat, so namespaced models produce collapsed input type names.
    def input_type_class_name
      @input_type_class_name ||= class_name.gsub("::", "")
    end

    def collapsed_file_name
      @collapsed_file_name ||= input_type_class_name.underscore
    end

    def argument_call_for(key, dry_type)
      typing = dry_type.gql_typing
      input_key = typing.input_key_for key
      opts = typing.argument_options
      type = opts.delete :type
      desc = opts.delete(:description).to_s.indent(2).strip

      opt_str = [].tap do |arr|
        arr << "loads: ::#{opts[:loads].name}" if opts[:loads].present?
        arr << "as: #{key.to_sym.inspect}" if input_key.to_s != key.to_s
        arr << "required: #{opts[:required].present?}"
        arr << "default_value: #{opts[:default_value].inspect}" if opts.key?(:default_value) && !opts[:default_value].nil?
        arr << "replace_null_with_default: true" if opts[:replace_null_with_default]
      end.join(", ")

      declaration = [].tap do |dec|
        dec << input_key.inspect
        dec << arg_type_inspect(type)
        dec << opt_str unless opt_str.empty?
      end.join(", ")

      <<~RUBY.indent(6).strip
      argument #{declaration} do
        description <<~TEXT
        #{desc}
        TEXT
      end
      RUBY
    end

    def arg_type_inspect(type)
      case type
      in Array
        type.map { arg_type_inspect(_1) }.join(", ").then { "[#{_1}]" }
      in Class
        "::#{type.name}"
      in Hash
        [].tap do |out|
          out << "{ "
          type.each do |k, v|
            out << "#{k}: #{arg_type_inspect(v)}"
          end
          out << " }"
        end.join
      else
        type.to_s
      end
    end

    def scope_klass
      @scope_klass ||= scope_klass_name.constantize
    end

    def scope_klass_name
      @scope_klass_name ||= derive_scope_klass_name
    end

    def derive_scope_klass_name
      "::Filtering::Scopes::#{class_name.pluralize}"
    end
  end
end
