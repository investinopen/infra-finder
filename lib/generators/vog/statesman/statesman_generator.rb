# frozen_string_literal: true

module VOG
  class StatesmanGenerator < Rails::Generators::NamedBase
    namespace "vog:statesman"

    source_root File.expand_path("templates", __dir__)

    class_option :states, type: :array, default: [], desc: "The states for the state machine"

    # @return [void]
    def validate!
      raise "must provide at least two states" unless states.many?
      raise "state names must be unique" unless states.map(&:name).uniq.size == states.size
    end

    def create_enum_type!
      template "enum_type.rb", Rails.root.join("app/graphql/types/#{enum_type_class_name.underscore}.rb")
    end

    def create_transition_model!
      template "transition_model.rb", Rails.root.join("app/models/#{transition_class_name.underscore}.rb")
    end

    def create_transition_policy!
      template "transition_policy.rb", Rails.root.join("app/policies/#{transition_class_name.underscore}_policy.rb")
    end

    def create_state_machine!
      destination = Rails.root.join("app/services/#{service_namespace.underscore}/state_machine.rb")

      if destination.exist?
        say_status :skip, "#{destination} already exists", :yellow
        return
      end

      template "state_machine.rb", destination
    end

    def create_transition_type!
      template "transition_type.rb", Rails.root.join("app/graphql/types/#{transition_type_class_name.underscore}.rb")
    end

    def create_transition_edge_type!
      template "transition_edge_type.rb", Rails.root.join("app/graphql/types/#{transition_edge_type_class_name.underscore}.rb")
    end

    def create_transition_connection_type!
      template "transition_connection_type.rb", Rails.root.join("app/graphql/types/#{transition_connection_type_class_name.underscore}.rb")
    end

    def create_transition_resolver!
      template "transition_resolver.rb", Rails.root.join("app/services/resolvers/#{transition_resolver_class_name.underscore}.rb")
    end

    private

    def base_association = class_name.underscore

    def enum_type = "#{class_name.underscore}_state"

    def enum_type_class_name = "#{enum_type.classify}Type"

    def full_enum_type_class_name = "Types::#{enum_type_class_name}"

    def full_state_machine_class_name = "#{service_namespace}::StateMachine"

    def full_transition_connection_type_class_name = "Types::#{transition_connection_type_class_name}"

    def full_transition_edge_type_class_name = "Types::#{transition_edge_type_class_name}"

    def full_transition_type_class_name = "Types::#{transition_type_class_name}"

    def service_namespace = class_name.pluralize

    def transition_class_name = "#{class_name}Transition"

    def transition_connection_type_class_name = "#{transition_class_name}ConnectionType"

    def transition_edge_type_class_name = "#{transition_class_name}EdgeType"

    def transition_type_class_name = "#{transition_class_name}Type"

    def transition_resolver_class_name = "#{transition_class_name}Resolver"

    def transitions_association_name = "#{base_association}_transitions"

    def model_name = class_name

    def owner_words = class_name.underscore.humanize.downcase

    def states
      @states ||= Array(options[:states]).map.with_index do |name, index|
        initial = index.zero?

        State.new(name:, initial:)
      end
    end

    class State < ::Support::FlexibleStruct
      attribute :name, ::Support::Types::String.constrained(filled: true)
      attribute? :initial, ::Support::Types::Bool.default(false)

      alias initial? initial

      # @return [String]
      def enum_name = name.upcase.inspect

      # @return [String]
      def enum_value = name.inspect

      def human = name.humanize.downcase

      # @return [String]
      def machine_name = name.to_sym.inspect

      # @return [String]
      def machine_declaration
        [].tap do |parts|
          parts << "state #{machine_name}"
          parts << "initial: true" if initial?
        end.join(", ")
      end
    end
  end
end
