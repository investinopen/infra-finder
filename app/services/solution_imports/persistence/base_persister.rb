# frozen_string_literal: true

module SolutionImports
  module Persistence
    # @abstract
    class BasePersister < SolutionImports::Subprocessor
      include Dry::Effects.State(:intakes_count)
      include Dry::Effects.State(:providers_count)
      include Dry::Effects.State(:solutions_count)

      private

      # @param [SolutionImportable] importable
      # @return [void]
      def count_import_of!(importable)
        case importable
        in Provider
          self.providers_count += 1
        in Solution
          self.solutions_count += 1
        in SolutionIntake
          self.intakes_count += 1
        else
          # :nocov:
          # intentionally left blank
          # :nocov:
        end
      end

      # @param [SolutionImportable] importable
      # @return [void]
      def track_import_of!(importable)
        importable.add_imported_tag!

        count_import_of! importable

        Success()
      end

      # @api private
      module EachPersister
        extend ActiveSupport::Concern

        included do
          include Dry::Effects.Cache(:persistence)
        end

        # @return [Provider]
        attr_reader :provider

        private

        # @return [Dry::Monads::Success(Provider)]
        # @return [Dry::Monads::Failure(:unknown_provider, String)]
        def find_provider
          provider = cache :provider, provider_identifier do
            Provider.find_by!(identifier: provider_identifier)
          end
        rescue ActiveRecord::RecordNotFound
          # :nocov:
          Failure[:unknown_provider, provider_identifier]
          # :nocov:
        else
          Success provider
        end

        # @return [Dry::Monads::Success(nil)]
        # @return [Dry::Monads::Success(Provider)]
        # @return [Dry::Monads::Failure(:unknown_provider, String)]
        def maybe_find_provider
          return Success(nil) if provider_identifier.blank?

          find_provider
        end

        # @param [Solution, SolutionDraft, SolutionIntake] record
        # @param [SolutionProperties::Assignment] assignment
        # @return [void]
        def try_attachment!(record, assignment)
          attachment = assignment.attribute_name

          assignment.assign! record

          unless record.save
            logger.tagged("attachment:#{attachment}") do
              record.errors.messages_for(attachment).each do |message|
                logger.warn "Ignoring #{attachment} failure: #{message}"
              end
            end

            record.reload

            record.__send__(:"#{attachment}=", nil)
            record.__send__(:"#{attachment}_remote_url=", nil)
          end
        end
      end
    end
  end
end
