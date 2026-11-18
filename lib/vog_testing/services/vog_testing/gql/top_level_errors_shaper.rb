# frozen_string_literal: true

module VOGTesting
  module GQL
    class TopLevelErrorsShaper < VOGTesting::GQL::AbstractShaper
      ENUM_VALUE_EXPLANATION = "Expected %<entry>s to be one of: %<value_list>s"

      # @param [String] value
      # @param [Class(Types::BaseEnum)] type
      # @return [<Hash>]
      def invalid_enum_value(value, type)
        entry = value.inspect

        value_list = type.values.keys.join(", ")

        explanation = ENUM_VALUE_EXPLANATION % { entry:, value_list:, }

        error do |o|
          o[:message] = include(explanation)
        end
      end

      # @return [<Hash>]
      def invalid_one_of(type, variable: "$with")
        error do |o|
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

      NON_NULL_EXPLANATION = "%<name>s can't be null"

      # @param [#to_s] variable the name the variable that mustn't be null.
      # @return [<Hash>]
      def non_null(variable)
        name = variable.to_s.camelize(:lower)

        explanation = NON_NULL_EXPLANATION % { name: }

        error do |o|
          o[:message] = include(explanation)
        end
      end

      # @return [<Hash>]
      def unauthorized
        error do |o|
          o.prop :extensions do |ext|
            ext[:code] = "FORBIDDEN"
          end

          o[:message] = I18n.t("server_messages.auth.forbidden")
        end
      end

      # @api private
      # @return [<Hash>]
      def error
        errors do |a|
          a.item do |o|
            yield o
          end
        end
      end

      # @api private
      # @return [<Hash>]
      def errors
        array do |a|
          yield a
        end
      end
    end
  end
end
