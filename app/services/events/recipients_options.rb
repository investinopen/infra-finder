# frozen_string_literal: true

module Events
  class RecipientsOptions < Support::FlexibleStruct
    include Support::Typing

    attribute? :admins, Types::Bool.default(false)
    attribute? :editors, Types::Bool.default(false)
    attribute? :associated, Types::Bool.default(false)

    alias admins? admins
    alias editors? editors
    alias associated? associated

    # @param [Hash] new_options the options to merge in
    # @return [Events::RecipientsOptions] a new instance with the given options merged in
    def merge(**new_options)
      self.class.new(to_h.merge(new_options))
    end
  end
end
