# frozen_string_literal: true

# A shared extension for the two `Noticed` models.
module NoticedCommonExtension
  extend ActiveSupport::Concern

  include PostgresEnums
  include TimestampScopes

  include Support::CallsCommonOperation

  included do
    extend DefinesMonadicOperation
  end
end
