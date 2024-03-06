# frozen_string_literal: true

# A record that can be imported by the {SolutionImports} subsystem.
#
# @see SolutionImport
module SolutionImportable
  extend ActiveSupport::Concern

  include HasSystemTags

  IMPORTED_TAG = "Imported"

  included do
    scope :was_imported, -> { with_system_tags(IMPORTED_TAG) }
  end

  # @return [void]
  def add_imported_tag!
    system_tag_list.add IMPORTED_TAG

    save!
  end
end
