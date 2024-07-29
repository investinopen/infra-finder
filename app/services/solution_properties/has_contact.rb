# frozen_string_literal: true

module SolutionProperties
  # Define and expose properties related to contact information for a {SolutionInterface}.
  module HasContact
    extend ActiveSupport::Concern

    included do
      pg_enum! :contact_method, as: :contact_method, prefix: :contact_via, allow_blank: false, default: :unavailable

      alias_method :contact_unavailable?, :contact_via_unavailable?

      scope :contact_unavailable, -> { contact_via_unavailable }

      before_validation :derive_contact_method!
    end

    # @api private
    # @return [String]
    def derive_contact_method
      case contact
      when /\Amailto:\S+\z/
        "email"
      when Support::GlobalTypes::URL_PATTERN
        "website"
      else
        "unavailable"
      end
    end

    # @api private
    # @return [void]
    def derive_contact_method!
      self.contact_method = derive_contact_method
    end
  end
end
