# frozen_string_literal: true

module SolutionProperties
  class FreeInputs
    include Support::EnhancedStoreModel

    strip_attributes allow_empty: false, collapse_spaces: true, replace_newlines: false

    SolutionProperty.each_free_input do |prop|
      attribute prop.free_input_name, :string
    end
  end
end
