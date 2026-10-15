# frozen_string_literal: true

# Instance methods for {AnonymousUser}.
module AnonymousInterface
  extend ActiveSupport::Concern

  include GlobalID::Identification

  # A static ID to allow {AnonymousUser} to be encoded as a GlobalID.
  ID = "ANONYMOUS"

  # @note Always true for an {AnonymousUser}.
  def anonymous? = true

  alias anonymous anonymous?

  # @return [false]
  def authenticated? = false

  # @!attribute [r] created_at
  # @note An anonymous user's created time is always at the time of the request.
  # @return [ActiveSupport::TimeWithZone]
  def created_at = Time.current

  # @return [nil]
  def email = nil

  # @return [Class(Types::UserType)]
  def graphql_node_type = ::Types::UserType

  # @!attribute [r] id
  # A static ID to allow {AnonymousUser} to be encoded as a GlobalID.
  # @return ["ANONYMOUS"]
  def id = ID

  # @return [:anonymous]
  def kind = :anonymous

  # @return [String]
  def name = "Anonymous User"

  # @return [0]
  def sign_in_count = 0

  # @see UserPolicy
  # @return [Class(UserPolicy)]
  def policy_class = ::UserPolicy

  # {AnonymousUser Anonymous users} are non-blank for purposes of object presence.
  #
  # @note Because of Naught's treatment of predicates, this would return `false`
  #   unless subsequently overridden.
  def present? = true

  # Relies upon {AnonymousInterface::ClassMethods#empty_user} for delegation.
  #
  # @api private
  # @param [Symbol, String] method_name
  # @param [Boolean] include_private
  def respond_to_missing?(method_name, include_private = false)
    AnonymousUser.empty_user.respond_to?(method_name, include_private) || super
  end

  # @see ::Support::RelayNode::IdFromObject
  # @return [String, nil]
  def to_encoded_id
    Support::System["relay_node.id_from_object"].(self).value!
  end

  # @!attribute [r] updated_at
  # @note An anonymous user's last updated time is always at the time of the request.
  # @return [ActiveSupport::TimeWithZone]
  def updated_at = Time.current

  # Class methods for {AnonymousUser}.
  module ClassMethods
    # A simulation of `ApplicationRecord.find` to allow {AnonymousUser} to be decoded from a GlobalID.
    #
    # In effect, `AnonymousUser.find any_id` is equivalent to calling `AnonymousUser.new`.
    #
    # @return [AnonymousUser]
    def find(*) = new

    # @!attribute [r] empty_user
    # An empty, read-only user instance used for better
    # method_missing delegation than `naught` can infer.
    # @api private
    # @see AnonymousInterface#respond_to_missing?
    # @return [User]
    def empty_user
      @empty_user ||= User.new.tap(&:readonly!)
    end

    # @see UserPolicy
    # @return [Class(UserPolicy)]
    def policy_class = ::UserPolicy
  end
end
