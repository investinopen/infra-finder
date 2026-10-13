# frozen_string_literal: true

module VOGTesting
  class GQLShaper
    def mutation(...)
      ::VOGTesting::GQL::MutationShaper.build(...)
    end

    def named(...)
      ::VOGTesting::GQL::NamedObjectShaper.build(...)
    end

    def object(...)
      ::VOGTesting::GQL::ObjectShaper.build(...)
    end

    alias query object

    def objects(...)
      ::VOGTesting::GQL::ObjectsShaper.build(...)
    end

    alias array objects

    # @param [String, Symbol] name
    # @return [Hash]
    def empty_mutation(name)
      query do |q|
        q[name] = nil
      end
    end

    def top_level_invalid_one_of(type, variable: "$with")
      array do |a|
        a.item do |o|
          o.prop :extensions do |ext|
            ext.array :problems do |probs|
              probs.item do |p|
                p[:explanation] = "'#{type}' requires exactly one argument, but 0 were provided."
              end
            end
          end

          o[:message] = "Variable #{variable} of type #{type}! was provided invalid value"
        end
      end
    end

    def top_level_unauthorized
      array do |a|
        a.item do |o|
          o.prop :extensions do |ext|
            ext[:code] = "FORBIDDEN"
          end

          o[:message] = I18n.t("server_messages.auth.forbidden")
        end
      end
    end

    def attribute_errors(...)
      ::VOGTesting::GQL::AttributeErrorsBuilder.build(...)
    end

    def attribute_error_on(...)
      ::VOGTesting::GQL::AttributeErrorBuilder.build(...)
    end
  end
end
