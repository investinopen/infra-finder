# frozen_string_literal: true

class CommentNotificationsMailer < ApplicationMailer
  before_action :extract_common_params!

  default subject: -> { t(".subject", description: @description) },
    to: -> { @recipient.email }

  def created
    mail
  end

  private

  # @return [void]
  def extract_common_params!
    @comment = params.fetch(:comment)
    @resource = @comment.resource
    @author = @comment.author
    @recipient = @user = params.fetch(:recipient)

    @description = display_name_for(@resource)

    @view_url = view_url_for(@comment)
  end

  # @param [ActiveAdmin::Comment] comment
  def view_url_for(comment)
    anchor = anchor_for(comment)

    admin_show_url_for(comment.resource, anchor:)
  end
end
