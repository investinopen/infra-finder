# frozen_string_literal: true

class ComparisonSharesController < ApplicationController
  comparison_load_strategy :fetch

  def show
    @comparison_share = ComparisonShare.find params[:id]

    current_comparison.accept_shared @comparison_share do |m|
      m.success do |_, changed|
        @comparison_share.used! if changed

        # f for "filters"
        if params[:m] == ?f
          redirect_to solutions_path
        else
          render_current_comparison!
        end
      end

      m.failure do
        # :nocov:
        redirect_to solutions_path, alert: t(".invalid_share_id")
        # :nocov:
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to solutions_path, alert: t(".invalid_share_id")
  end

  def shared
    @comparison_share = ComparisonShare.find params[:id]

    @comparison_share.shared!

    head :no_content
  rescue ActiveRecord::RecordNotFound
    # :nocov:
    head :not_found
    # :nocov:
  end
end
