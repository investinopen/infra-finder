# frozen_string_literal: true

module Implementations
  # Combines a solution's implementation data with its status column for
  # {Types::SolutionImplementationType}.
  class GraphQLView
    include Dry::Initializer[undefined: false].define -> do
      param :solution, Dry::Types["any"]
      param :implementation, Dry::Types["any"]
    end

    # @return [String, nil]
    def status
      solution.public_send(implementation.enum)
    end

    # @return [<Implementations::Link>]
    def links
      case implementation.link_mode
      when :many then data.links
      when :single then [data.link].reject { _1.url.blank? && _1.label.blank? }
      else
        []
      end
    end

    # @return [String, nil]
    def statement
      data.statement if implementation.has_statement?
    end

    private

    # @return [Implementations::AbstractImplementation]
    def data
      solution.public_send(implementation.name)
    end
  end
end
