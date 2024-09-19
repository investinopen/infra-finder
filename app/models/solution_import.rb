# frozen_string_literal: true

# @see SolutionImports
# @see SolutionImportTransition
class SolutionImport < ApplicationRecord
  include HasAutoincrementingIdentifier
  include HasStoredMessages
  include ImportSourceUploader::Attachment.new(:source)
  include TimestampScopes
  include UsesStatesman

  has_state_machine!

  pg_enum! :strategy, as: :solution_import_strategy, allow_blank: false

  expose_ransackable_associations! :user, on: :admin

  expose_ransackable_attributes! :id, :strategy, :user_id, :created_at, :updated_at, on: :admin

  self.filter_attributes = %i[messages]

  attribute :options, SolutionImports::Options.to_type, default: proc { {} }
  attribute :metadata, SolutionImports::Metadata.to_type, default: proc { {} }

  belongs_to :user, optional: true

  scope :pending, -> { in_state(:pending) }
  scope :invalid, -> { in_state(:invalid) }
  scope :started, -> { in_state(:started) }
  scope :success, -> { in_state(:success) }
  scope :failure, -> { in_state(:failure) }

  validates :source, :strategy, presence: true

  delegate :auto_approve?, to: :options

  after_commit :asynchronously_process!, on: :create, unless: :skip_process?

  # @!attribute [rw] skip_process
  # Set this during create to skip enqueuing the background job.
  # @return [Boolean]
  attr_accessor :skip_process

  alias skip_process? skip_process

  # @api private
  # @see SolutionImports::ProcessJob
  # @return [void]
  def asynchronously_process!
    SolutionImports::ProcessJob.perform_later self
  end

  # Process this import.
  #
  # @see SolutionImports::Process
  # @see SolutionImports::Processor
  # @return [Dry::Monads::Success(SolutionImport)]
  monadic_matcher! def process
    call_operation("solution_imports.process", self)
  end

  # @return [SolutionImport]
  def reset!
    # :nocov:
    solution_import_transitions.delete_all

    current_state(force_reload: true)

    reload
    # :nocov:
  end

  # @param [Hash] new_options
  def options_attributes=(new_options)
    self.options = new_options
  end

  class << self
    # @return [<(String, String)>]
    def strategy_select_options
      pg_enum_select_options(:solution_import_strategy, skip: :legacy)
    end
  end
end
