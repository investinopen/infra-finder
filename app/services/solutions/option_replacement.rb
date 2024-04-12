# frozen_string_literal: true

module Solutions
  class OptionReplacement < Support::WritableStruct
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attribute :old_option, Types::Option
    attribute? :new_option, Types::Option

    validates :new_option, presence: true

    validate :check_same_option!

    validate :check_option_type!

    # @param [Hash] params
    # @option [String] "new_option"
    # @return [void]
    def update_from_form!(params)
      self.new_option = old_option.class.find(params["new_option"])

      self
    end

    def persisted?
      false
    end

    private

    def check_same_option!
      errors.add :new_option, :same_option if old_option == new_option
    end

    def check_option_type!
      errors.add :new_option, :type_mismatch if new_option.present? && old_option.class != new_option.class
    end
  end
end
